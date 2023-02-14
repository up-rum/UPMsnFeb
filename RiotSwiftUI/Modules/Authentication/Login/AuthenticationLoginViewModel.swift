//
// Copyright 2021 New Vector Ltd
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

import SwiftUI
import MatrixSDK

typealias AuthenticationLoginViewModelType = StateStoreViewModel<AuthenticationLoginViewState,AuthenticationLoginViewAction>

class AuthenticationLoginViewModel: AuthenticationLoginViewModelType, AuthenticationLoginViewModelProtocol {
    

    // MARK: - Properties

    // MARK: Public

    var callback: (@MainActor (AuthenticationLoginViewModelResult) -> Void)?
    var callback2: (@MainActor (AuthenticationServerSelectionViewModelResult) -> Void)?


    // MARK: - Setup

    init(homeserver: AuthenticationHomeserverViewData) {
        let bindings = AuthenticationLoginBindings()
        let viewState = AuthenticationLoginViewState(homeserver: homeserver, bindings: bindings)
        
        super.init(initialViewState: viewState)
    }
    
    // MARK: - Public

    override func process(viewAction: AuthenticationLoginViewAction) {
        switch viewAction {
        case .selectServer:
            Task { await callback2?(.confirm(homeserverAddress: "matrix.unpluggedsystems.app")) }
//            Task { await callback?(.selectServer) }
        case .parseUsername:
            Task { await callback?(.parseUsername(state.bindings.username)) }
        case .forgotPassword:
            Task { await callback?(.forgotPassword) }
        case .next:
            Task { await self.upLoginApi(username: state.bindings.username, password: state.bindings.password)}
//            Task { await callback?(.login(username: state.bindings.username, password: state.bindings.password)) }
        case .poptoroot:
            Task { await callback?(.gotoroot) }
        case .fallback:
            Task { await callback?(.fallback) }
        case .continueWithSSO(let provider):
            Task { await callback?(.continueWithSSO(provider))}
        }
    }

    @MainActor func upLoginApi(username:String, password:String) {
        APIServices.shared.callCreateLogin(queryItems: nil, parameters: ["username": username, "password": password], success: { result in
            MXLog.warning("resultt === >> \(result)")
            UserDefaults.standard.set(result?.token, forKey: "uptoken")
            self.callback?(.login(username: username, password: password))

        }, failure: { failureMsg in
            self.displayError(AuthenticationLoginErrorType.mxError("Incorrect username or password"))
        })

    }
    
    @MainActor func update(isLoading: Bool) {
        guard state.isLoading != isLoading else { return }
        state.isLoading = isLoading
    }
    
    @MainActor func update(homeserver: AuthenticationHomeserverViewData) {
        state.homeserver = homeserver
    }
    
    @MainActor func displayError(_ type: AuthenticationLoginErrorType) {
        switch type {
        case .mxError(let message):
            state.bindings.alertInfo = AlertInfo(id: type,
                                                 title: VectorL10n.error,
                                                 message: message)
        case .invalidHomeserver:
            state.bindings.alertInfo = AlertInfo(id: type,
                                                 title: VectorL10n.error,
                                                 message: VectorL10n.authenticationServerSelectionGenericError)
        case .unknown:
            state.bindings.alertInfo = AlertInfo(id: type)
        }
    }
}
