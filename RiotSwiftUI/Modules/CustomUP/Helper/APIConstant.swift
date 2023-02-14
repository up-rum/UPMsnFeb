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

struct ServerURLs {
    var upHomeServerUrl: (String) {
        if Bundle.main.bundleIdentifier!.contains("dev") {
            return "matrix.unpluggedsystems.app"
        } else {
            return "msg.unpluggedsystems.app"
        }
    }
    var apiBaseUrl: (String) {
        if Bundle.main.bundleIdentifier!.contains("dev") {
            return "https://up-app-dev.unpluggedsystems.app/api/"
        } else {
            return "https://up-app.unpluggedsystems.app/api/"
        }
    }
    var jitsiServerUrl: (String) {
        if Bundle.main.bundleIdentifier!.contains("dev") {
            return "https://jt.unpluggedsystems.app"
        } else {
            return "https://jt.unplugged.com"
        }
    }
    var jitsiWebUrl: (String) {
        if Bundle.main.bundleIdentifier!.contains("dev") {
            return "https://web.unpluggedsystems.app"
        } else {
            return "https://web.unplugged.com"
        }
    }
}
//var baseUrl = "https://up-app-dev.unpluggedsystems.app/api/"
//var homeServerUrl = "matrix.unpluggedsystems.app"
//var pushServerUrl = ""
//
//if (BuildSettings.baseBundleIdentifier.contains("-dev")) {
//     baseUrl = "https://up-app-dev.unpluggedsystems.app/api/"
//     homeServerUrl = "matrix.unpluggedsystems.app"
//     pushServerUrl = "https://sygnal.unpluggedsystems.app/_matrix/push/v1/notify"
//} else {
//     baseUrl = "https://up-app.unpluggedsystems.app/api/"
//     homeServerUrl = "msg.unpluggedsystems.app"
//     pushServerUrl = "https://push.unplugged.com/_matrix/push/v1/notify"
//}
