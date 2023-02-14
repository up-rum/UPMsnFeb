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


import SwiftUI
import Combine

typealias UPLoginViewModelType = StateStoreViewModel<UPLoginViewState,UPLoginViewAction>

protocol UPLoginViewModelProtocol {
    var completion: ((UPLoginViewModelResult) -> Void)? { get set }
    var context: UPLoginViewModelType.Context { get }
}

class UPLoginViewModel: UPLoginViewModelType, UPLoginViewModelProtocol {

    // MARK: - Properties

    // MARK: Private

    // MARK: Public

    var completion: ((UPLoginViewModelResult) -> Void)?

    // MARK: - Setup

    init() {
        super.init(initialViewState: UPLoginViewState())
    }

    // MARK: - Public

    override func process(viewAction: UPLoginViewAction) {
        switch viewAction {
        case .register:
            register()
        case .login:
            login()
        case .nextPage:
            // Wrap back round to the first page index when reaching the end.
            print("aa")
        case .previousPage:
            print("aa")
            // Prevent the hidden page at index -1 from being shown.
//            state.bindings.pageIndex = max(0, (state.bindings.pageIndex - 1))
        case .hiddenPage:
            print("aa")
            // Hidden page for a nicer animation when looping back to the start.
//            state.bindings.pageIndex = -1
        }
    }

    private func register() {
        completion?(.register)
    }

    private func login() {
        completion?(.login)
    }
}
