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

typealias OnboardingUseCaseViewModelType = StateStoreViewModel<OnboardingUseCaseViewState, OnboardingUseCaseViewAction>

class OnboardingUseCaseViewModel: OnboardingUseCaseViewModelType, OnboardingUseCaseViewModelProtocol {

    // MARK: - Properties

    // MARK: Private

    // MARK: Public

    
    var completion: ((OnboardingUseCaseViewModelResult) -> Void)?
    var callback: (@MainActor (OnboardingUseCaseViewModelResult) -> Void)?


    // MARK: - Setup

    init() {
        super.init(initialViewState: OnboardingUseCaseViewState())
    }

    // MARK: - Public

    override func process(viewAction: OnboardingUseCaseViewAction) {
        switch viewAction {
        case .answer(let result):
            completion?(result)
        case .validateUsername:
            Task { await validateUsername() }
        }
        
    }

    
//    override class func reducer(state: inout OnboardingUseCaseViewState, action: OnboardingUseCaseStateAction) {
//        // There is no mutable state to reduce :)
//    }

//    @MainActor func displayError(_ type: AuthenticationRegistrationErrorType) {
//        switch type {
//        case .usernameUnavailable(let message):
//            state.usernameAvailability = .invalid(message)
//        case .mxError(let message):
//            state.usernameAvailability = .invalid(message)
////            state.bindings.alertInfo = AlertInfo(id: type,
////                                                 title: VectorL10n.error,
////                                                 message: message)
//        case .invalidHomeserver, .invalidResponse:
//            state.usernameAvailability = .invalid("message")
////            state.bindings.alertInfo = AlertInfo(id: type,
////                                                 title: VectorL10n.error,
////                                                 message: VectorL10n.authenticationServerSelectionGenericError)
//        case .registrationDisabled:
//            state.usernameAvailability = .invalid("message")
////            state.bindings.alertInfo = AlertInfo(id: type,
////                                                 title: VectorL10n.error,
////                                                 message: VectorL10n.loginErrorRegistrationIsNotSupported)
//        case .unknown:
//            state.usernameAvailability = .invalid(message)
////            state.bindings.alertInfo = AlertInfo(id: type)
//        }
//    }

    @MainActor private func validateUsername()  {
//        if !state.hasEditedUsername {
//            state.hasEditedUsername = true
//        }
        APIServices.shared.checkUPUsername(username: "tu01") { (responseDict, error) in
            guard let response = responseDict else{
                return
            }
            if let status = response["error"] as? String {
                print("username already exist")
            }else{
                print(response["error"] ?? "")
            }
        }
//        callback?(.validateUsername(state.bindings.username))
    }

}
