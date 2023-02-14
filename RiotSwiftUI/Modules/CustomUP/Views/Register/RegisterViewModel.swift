// 
// Copyright 2022 New Vector Ltd
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
import Combine

class RegisterViewModel:  ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var confirmpassword = ""
    @Published var fname = ""
    @Published var lname = ""
    @Published var phone = ""
    @Published var email = ""
    @Published var createLoginResponse: CreateLoginResponse?

    @Published var isValid =  false




//    private var isUsernameValid: AnyPublisher<Bool, Never> {
//            $username
//                .debounce(for: 0.2, scheduler: RunLoop.main)
//                .removeDuplicates()
//                .map {
//                    if $0.isEmpty {
//                    self.errorUsername = "Invalid Username"
//                    return false
//                } else {
//                    self.errorUsername = ""
//                    return true
//                } }
//                .eraseToAnyPublisher()
//        }
//
//        private var isPasswordValid: AnyPublisher<Bool, Never> {
//            $password
//                .debounce(for: 0.2, scheduler: RunLoop.main)
//                .removeDuplicates()
//                .map {
//                    if $0.isEmpty {
//                    self.errorPassword = "Invalid Password"
//                    return false
//                } else {
//                    self.errorPassword = ""
//                    return true
//                } }
//                .eraseToAnyPublisher()
//        }

//        private var isFormValid: AnyPublisher<Bool, Never> {
//            Publishers.CombineLatest(isUsernameValid, isPasswordValid)
//                .debounce(for: 0.2, scheduler: RunLoop.main)
//                .map { $0 && $1 }
//                .eraseToAnyPublisher()
//        }

//    func createSignup(request: RegistrationRequest) {
//        APIServices.shared.callRegistrationApi(parameters: request.dictionary ?? [:]) { response in
//            if let response = response {
////                print(response)
//                Task { await callback?(.login(username: state.bindings.username, password: state.bindings.password))}
//            }
//        }
//            failure: { error in
////               print(error)
//            }
//    }
}
