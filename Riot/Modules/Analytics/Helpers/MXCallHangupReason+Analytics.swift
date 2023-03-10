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

import AnalyticsEvents

extension __MXCallHangupReason {
    var errorName: AnalyticsEvent.Error.Name {
        switch self {
        case .userHangup:
            return .VoipUserHangup
        case .userBusy:
            // There is no dedicated analytics event for `userBusy` error
            return .UnknownError
        case .inviteTimeout:
            return .VoipInviteTimeout
        case .iceFailed:
            return .VoipIceFailed
        case .iceTimeout:
            return .VoipIceTimeout
        case .userMediaFailed:
            return .VoipUserMediaFailed
        case .unknownError:
            return .UnknownError
        default:
            MXLog.failure("Unknown or unhandled hangup reason", context: [
                "reason": rawValue
            ])
            return .UnknownError
        }
    }
}
