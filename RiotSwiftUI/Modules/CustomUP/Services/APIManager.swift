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
import Alamofire
import MatrixSDK

public typealias FailureMessage = String

/**
 API Manager is a singleton class for handle all network call.
 */
public class APIManager {
    // A Singleton instance
    public static let shared = APIManager()

    ///   - serverURL:        Optional value for pass your root url.
    ///   - strURL:                         String URL value.
    ///   - queryItems:                  add number of parameters in the API request
    ///   - method:                        `HTTPMethod` for the `URLRequest`. `.get` by default.
    ///   - headers:                       `HTTPHeaders` value to be added to the `URLRequest`. `nil` by default.
    ///   - parameters:    `Parameters` (a.k.a. `[String: Any]`) value to be encoded into the `URLRequest`. `nil` by default.
    ///   - success:                        Completion handler for get `Data`
    ///   - failure:                           Completion handler for get `FailureMessage`(a.k.a. `String`)

    func callAPI(serverURL: String? = "", strURL: String, queryItems: [URLQueryItem]? = nil, method: HTTPMethod = .get, headers: HTTPHeaders? = nil, parameters: Parameters? = nil, success: @escaping ((AFDataResponse<Any>) -> Void), failure: @escaping ((FailureMessage) -> Void)) {
//        var finalURL = serverURL ?? ""

//        if let serverURL = serverURL, serverURL == "" {
//            finalURL = AppConstants.serverURL
//        }

        guard var url = URLComponents(string: "\(strURL)") else {
            failure("Invalid URL")
            return
        }

        if let queryItems = queryItems {
            url.queryItems = queryItems
        }
        MXLog.warning(headers ?? "")
        // Network request
        AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                if response.response?.statusCode ?? 0 >= 200 {
                    success(response)
                } else {
                    failure(response.error?.localizedDescription ?? "Something went wrong")
                }
            }
    }
}
//{"id":"62f7f8cdc46ba106cfd37a1c","firstName":"Test","username":"tu01","lastName":"User","email":"Rumania.abid01@gmail.com","phoneNumber":"","birthday":null,"messagingDomain":"matrix.unpluggedsystems.app","subscriptionExpirationDate":null,"subscriptionId":null,"subscribeEmailUpdates":false}
