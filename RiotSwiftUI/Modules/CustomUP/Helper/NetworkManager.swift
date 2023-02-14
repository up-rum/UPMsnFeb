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

class NetworkManager{
    func getRequest(url: String, completion: @escaping (_ response:[String : Any]?, _ error: Error?) -> Void){
        let request = AF.request(url, method: .get)
        request.responseJSON { response in
            var headers: [String: String] = [:]
            var body: [String: Any]?
            var errorDescription: Error?
            if let response = response.response {
                for (field, value) in response.allHeaderFields {
                    headers["\(field)"] = "\(value)"
                }
            }
            if case let .failure(error) = response.result {
                errorDescription = error
            }
            if case let .success(value) = response.result {
                body = value as? [String: Any]

            }
            DispatchQueue.main.async {
                completion(body,errorDescription)
            }

        }
    }


    func postUrlEncodeFormStringResponse(url: String, parameters: [String: Any], completion
                                            :@escaping (_ response:[String : Any]?, _ error: Error?) -> Void){
        var defaultHeaders = HTTPHeaders()
        defaultHeaders["content-type"] = "application/json"
//        defaultHeaders["Content-Type"] = "contenttype"
        AF.request(url,method: .post,parameters: parameters,encoding: URLEncoding.httpBody, headers: .init(defaultHeaders))
            .responseJSON { response in
                var headers: [String: String] = [:]
                var body: [String: Any]?
                var errorDescription: Error?
                if let response = response.response {
                    for (field, value) in response.allHeaderFields {
                        headers["\(field)"] = "\(value)"
                    }
                }
                if case let .failure(error) = response.result {
                    errorDescription = error
                }
                if case let .success(value) = response.result {
                    body = value as? [String: Any]

                }
                DispatchQueue.main.async {
                    completion(body,errorDescription)
                }

            }
    }


}


