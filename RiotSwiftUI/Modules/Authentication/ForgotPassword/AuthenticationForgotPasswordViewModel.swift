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

typealias AuthenticationForgotPasswordViewModelType = StateStoreViewModel<AuthenticationForgotPasswordViewState, AuthenticationForgotPasswordViewAction>
class AuthenticationForgotPasswordViewModel: AuthenticationForgotPasswordViewModelType, AuthenticationForgotPasswordViewModelProtocol {

    // MARK: - Properties

    // MARK: Private

    // MARK: Public

    var callback: (@MainActor (AuthenticationForgotPasswordViewModelResult) -> Void)?

    // MARK: - Setup

    init(homeserver: AuthenticationHomeserverViewData, emailAddress: String = "") {
        let viewState = AuthenticationForgotPasswordViewState(homeserver: homeserver,
                                                              bindings: AuthenticationForgotPasswordBindings(emailAddress: emailAddress, showingAlert: false))
        super.init(initialViewState: viewState)
    }

    // MARK: - Public
    
     override func process(viewAction: AuthenticationForgotPasswordViewAction) {
        switch viewAction {
        case .send:
//            Task { await self.forgotPasswordApi(username: state.bindings.emailAddress) }
            Task { await callback?(.send(state.bindings.emailAddress)) }
        case .resend:
            Task { await callback?(.send(state.bindings.emailAddress)) }
        case .done:
            Task { await callback?(.done) }
        case .cancel:
            Task { await callback?(.cancel) }
        case .goBack:
            Task { await callback?(.goBack) }
        }
    }
    
    @MainActor func updateForSentEmail() {
        state.hasSentEmail = true
    }

    @MainActor func goBackToEnterEmailForm() {
        state.hasSentEmail = false
    }
    @MainActor func forgotPasswordApi(username:String) {
        APIServices.shared.upForgotPasswordApi(username: username) { response in

            if response != nil {
//                print(response)
                self.state.bindings.showingAlert = true
            }
                          else{
                self.state.bindings.showingAlert = true
            }
        }
            failure: { error in
//               print(error)
                MXLog.warning("up==forgot==er = \(error)")
//                self.state.bindings.showingAlert = true
                self.displayError(.mxError("Request successfully sent, please check your mail."))
            }
    }

    @MainActor func displayAlert() {
        state.bindings.showingAlert = true
//        self.goBackToEnterEmailForm()

    }

    @MainActor func displayError(_ type: AuthenticationForgotPasswordErrorType) {
        self.goBackToEnterEmailForm()
        switch type {
        case .mxError(let message):
            state.bindings.alertInfo = AlertInfo(id: type,
                                                 title: "",
                                                 message: message)
        case .unknown:
            state.bindings.alertInfo = AlertInfo(id: type)
        }
    }
}
