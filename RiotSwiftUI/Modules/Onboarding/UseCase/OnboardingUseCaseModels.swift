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

import Foundation

// MARK: - Coordinator

// MARK: View model

enum OnboardingUseCaseStateAction {
    case viewAction(OnboardingUseCaseViewAction)
}

enum OnboardingUseCaseViewModelResult {
    case personalMessaging
    case workMessaging
    case communityMessaging
    case skipped
}

// MARK: View

struct OnboardingUseCaseViewState: BindableState {
    enum UsernameAvailability {
        /// The availability of the username is unknown.
        case unknown
        /// The username is available.
        case available
        /// The username is invalid for the following reason.
        case invalid(String)
    }
}
struct OnboardingUseCaseBindings {
    /// The username input by the user.
    var username = ""
    /// The password input by the user.
    var password = ""
    /// Information describing the currently displayed alert.
    var alertInfo: AlertInfo<AuthenticationRegistrationErrorType>?
}
enum OnboardingUseCaseViewAction {
    case answer(OnboardingUseCaseViewModelResult)
    case validateUsername(OnboardingUseCaseViewModelResult)
}
