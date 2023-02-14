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

// MARK: View model

enum UPLoginViewModelResult {
    case register
    case login
}

// MARK: View

struct UPLoginViewState: BindableState, CustomDebugStringConvertible {

    /// The colours of the background gradient shown behind the 4 pages.
    private let gradientColors = [
        Color(red: 0.95, green: 0.98, blue: 0.96),
        Color(red: 0.89, green: 0.96, blue: 0.97),
        Color(red: 0.95, green: 0.89, blue: 0.97),
        Color(red: 0.81, green: 0.95, blue: 0.91),
        Color(red: 0.95, green: 0.98, blue: 0.96)
    ]

    /// An array containing all content of the carousel pages
    var bindings: UPLoginBindings

    /// Custom debug description to reduce noise in the logs.
    var debugDescription: String {
        "UPLoginViewState at page \(bindings.pageIndex)."
    }

    /// The background gradient for all 4 pages and the hidden page at the start of the carousel.
    var backgroundGradient: Gradient {
        // Include the extra stop for the hidden page at the start of the carousel.
        let hiddenPageColor = gradientColors[gradientColors.count - 2]
        return Gradient(colors: [hiddenPageColor] + gradientColors)
    }

    init() {
        // The pun doesn't translate, so we only use it for English.
        let locale = Locale.current
        let page4Title = locale.identifier.hasPrefix("en") ? "Cut the slack from teams." : VectorL10n.onboardingSplashPage4TitleNoPun

        self.bindings = UPLoginBindings()
    }
}

struct UPLoginBindings {
    var pageIndex = 0
}

enum UPLoginViewAction {
    case register
    case login
    case nextPage
    case previousPage
    case hiddenPage
}
