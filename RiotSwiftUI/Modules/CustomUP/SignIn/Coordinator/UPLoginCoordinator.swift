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
import CommonKit

protocol UPLoginCoordinatorProtocol: Coordinator, Presentable {
    var completion: ((UPLoginViewModelResult) -> Void)? { get set }
}

final class UPLoginCoordinator: UPLoginCoordinatorProtocol {

    // MARK: - Properties

    // MARK: Private

    private let upLoginHostingController: VectorHostingController
    private var upLoginViewModel: UPLoginViewModelProtocol

    private var indicatorPresenter: UserIndicatorTypePresenterProtocol
    private var loadingIndicator: UserIndicator?

    // MARK: Public

    // Must be used only internally
    var childCoordinators: [Coordinator] = []
    var completion: ((UPLoginViewModelResult) -> Void)?

    // MARK: - Setup

    init() {
        let viewModel = UPLoginViewModel()
        let view = UPLoginScreen(viewModel: viewModel.context)
        upLoginViewModel = viewModel
        upLoginHostingController = VectorHostingController(rootView: view)
        upLoginHostingController.vc_removeBackTitle()

        indicatorPresenter = UserIndicatorTypePresenter(presentingViewController: upLoginHostingController)
    }

    // MARK: - Public
    func start() {
        MXLog.debug("[OnboardingSplashScreenCoordinator] did start.")
        upLoginViewModel.completion = { [weak self] result in
            MXLog.debug("[OnboardingSplashScreenCoordinator] OnboardingSplashScreenViewModel did complete with result: \(result).")
            guard let self = self else { return }
            switch result {
            case .login:
                self.startLoading()
                self.completion?(result)
            case .register:
                self.completion?(result)
            }
        }
    }

    func toPresentable() -> UIViewController {
        return upLoginHostingController
    }

    /// Stops any ongoing activities in the coordinator.
    func stop() {
        stopLoading()
    }

    // MARK: - Private

    /// Show an activity indicator whilst loading.
    private func startLoading() {
        loadingIndicator = indicatorPresenter.present(.loading(label: VectorL10n.loading, isInteractionBlocking: true))
    }

    /// Hide the currently displayed activity indicator.
    private func stopLoading() {
        loadingIndicator = nil
    }
}
