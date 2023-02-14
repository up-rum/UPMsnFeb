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

typealias LoginPageModelType = StateStoreViewModel<LoginViewState,LoginPageViewAction>

protocol LoginPageModelProtocol {
    var completion: ((LoginPageModelResult) -> Void)? { get set }
    var context: LoginPageModelType.Context { get }
}

class LoginViewModel: LoginPageModelType, LoginPageModelProtocol {

    // MARK: - Properties

    // MARK: Private

    // MARK: Public

    var completion: ((LoginPageModelResult) -> Void)?

    

    // MARK: - Public

    override func process(viewAction: LoginPageViewAction) {
        switch viewAction {
        case .register:
            register()
        case .login:
            login()

            // Hidden page for a nicer animation when looping back to the start.

        case .nextPage:
            print("")
        case .previousPage:
            print("")
        case .hiddenPage:
            print("")
        }
    }

    private func register() {
        completion?(.register)
    }

    private func login() {
        completion?(.login)
    }
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var passwordErrorMsg: String = ""
    @Published var usernameErrorMsg: String = ""
    @Published var createLoginResponse: CreateLoginResponse?
    @Published var canSuibmit: Bool = false
    private var cancelSet: Set<AnyCancellable> = []


//        private var isFormValid: AnyPublisher<Bool, Never> {
//            Publishers.CombineLatest4($isP, $isPasswordCriteriaValid, $isPasswordConfirmValid, $isAgeValid)
//                .map { isEmailCriteriaValid, isPasswordCriteriaValid, isPasswordConfirmValid, isAgeValid in
//                    return (isEmailCriteriaValid && isPasswordCriteriaValid && isPasswordConfirmValid && isAgeValid)
//                }
//                .assign(to: \.canSubmit, on: self)
//                .store(in: &cancellableSet)
//
//        }

    private var isUsernameValid: AnyPublisher<Bool, Never> {
            $username
                .debounce(for: 0.2, scheduler: RunLoop.main)
                .removeDuplicates()
                .map {
                    if $0.isEmpty {
                        self.canSuibmit = true
                    self.usernameErrorMsg = "Invalid Username"
                    return false
                } else {
                    self.canSuibmit = true
                    self.usernameErrorMsg = ""
                    return true
                } }
                .eraseToAnyPublisher()
        }

        private var isPasswordValid: AnyPublisher<Bool, Never> {
            $password
                .debounce(for: 0.2, scheduler: RunLoop.main)
                .removeDuplicates()
                .map {
                    if $0.isEmpty {
                    self.passwordErrorMsg = "Invalid Password"
                    return false
                } else {
                    self.passwordErrorMsg = ""
                    return true
                } }
                .eraseToAnyPublisher()
        }

        private var isFormValid: AnyPublisher<Bool, Never> {
            Publishers.CombineLatest(isUsernameValid, isPasswordValid)
                .debounce(for: 0.2, scheduler: RunLoop.main)
                .map { $0 && $1 }
                .eraseToAnyPublisher()
        }
    init() {
        super.init(initialViewState: LoginViewState())
        self.username
            .dropFirst()
//                 .receive(on: RunLoop.main)
//                 .map { $0.count > 1 ? "" : "username must at least have 2 characters" }
//                 .assign(to: \.usernameErrorMsg, on: self)
//                 .store(in: &cancelSet)
//
        $password.dropFirst()
                 .receive(on: RunLoop.main)
                 .map { $0.count > 4 ? "" : "username must at least have 5 characters" }
                 .assign(to: \.passwordErrorMsg, on: self)
                 .store(in: &cancelSet)
        Publishers.CombineLatest($username, $password)
            .map { username, password in
                return username == password
            }
            .assign(to: \.canSuibmit, on: self)
            .store(in: &cancelSet)
//        if $username.count() > 1 && $password.count > 4 {
//            canSuibmit = true
//        }
//        else{
//            canSuibmit = false
//        }

    }
    
    func createLogin(request: CreateLoginRequest) {
        APIServices.shared.callCreateLogin(parameters: request.dictionary ?? [:]) { response in
            if let response = response {
//                print(response)
            }
        }
            failure: { error in
//               print(error)
            }
    }
}
