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
import SwiftUI

/// Using an enum for the screen allows you define the different state cases with
/// the relevant associated data for each case.
enum MockInfoSheetScreenState: MockScreenState, CaseIterable {
    // A case for each state you want to represent
    // with specific, minimal associated data that will allow you
    // mock that screen.
    case sheet(title: String, subtitle: String, action: InfoSheet.Action)
    
    /// The associated screen
    var screenType: Any.Type {
        InfoSheet.self
    }
    
    /// A list of screen state definitions
    static var allCases: [MockInfoSheetScreenState] {
        // Each of the presence statuses
        [.sheet(title: VectorL10n.userSessionVerifiedSessionTitle, subtitle: VectorL10n.userSessionVerifiedSessionDescription, action: .init(text: VectorL10n.userSessionGotIt, action: { }))]
    }
    
    /// Generate the view struct for the screen state.
    var screenView: ([Any], AnyView) {
        let model: (title: String, subtitle: String, action: InfoSheet.Action)
        
        switch self {
        case let .sheet(title, subtitle, action):
            model = (title, subtitle, action)
        }
        let viewModel = InfoSheetViewModel(title: model.title, description: model.subtitle, action: model.action)
        
        // can simulate service and viewModel actions here if needs be.
        
        return (
            [model, viewModel],
            AnyView(InfoSheet(viewModel: viewModel.context)
                .environmentObject(AvatarViewModel.withMockedServices()))
        )
    }
}
