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

struct CreateLoginRequest: Codable {
    var username: String = ""
    var password: String = ""

}

struct RegistrationRequest: Codable {
    var username: String = ""
    var password: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var email: String = ""
    var phoneNumber: String = ""
    var ip: String = ""
    var subscribeEmailUpdates: Bool = false

}

struct RegistrationResponse: Codable {
    let id, firstName, username, lastName: String?
        let email, phoneNumber: String?
        let birthday: String?
        let messagingDomain: String?
        let subscriptionExpirationDate, subscriptionID: String?
        let subscribeEmailUpdates: Bool?
    
}

struct CreateLoginResponse: Codable {
    var token: String
    var refreshToken: String
}
