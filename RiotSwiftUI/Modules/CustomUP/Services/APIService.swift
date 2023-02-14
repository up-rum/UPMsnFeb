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
import Alamofire
import Foundation
import MatrixSDK

struct APIServices {
    public static let shared = APIServices()

    
    func upForgotPasswordApi(username: String, success: @escaping (_ result: Bool?) -> Void, failure: @escaping (_ failureMsg: FailureMessage) -> Void) {
        let headers = HTTPHeaders()
//        headers["content-type"] = "application/json"
        APIManager.shared.callAPI(strURL: ServerURLs().apiBaseUrl + "accounts/v2/password?username=\(username)", queryItems: nil, method: .post, headers: headers, parameters: nil, success: { response in
            do {
                print(response.response?.statusCode)
                if response.response?.statusCode == 200 {
                    success(true)
                }
                else{
                    success(false)
                }
               
            } catch {
                failure(FailureMessage(error.localizedDescription))
            }
        }, failure: { error in
            failure(FailureMessage(error))
        })
    }
    func upLastSyncApi(success: @escaping (_ result: Int?) -> Void, failure: @escaping (_ failureMsg: FailureMessage) -> Void) {
//        var headers =
        let packageName = "com.unplugged.messenger" //Bundle.main.bundleIdentifier ?? ""
        let buildVersion = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String ) ?? ""
        let token  = UserDefaults.standard.value(forKey: "uptoken") ?? ""
        MXLog.debug("token==>> \(["X-UP-APP": packageName, "X-UP-PLATFORM": "IOS",  "X-UP-VERSION": buildVersion])")
//        headers["Authorization"] = "Bearer \(token ?? "")"
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.SSSSSS'Z'"
        let date_st = dateFormatter.string(from: date)

        APIManager.shared.callAPI(strURL: (ServerURLs().apiBaseUrl + "last-sync"), queryItems: nil, method: .post, headers: ["Authorization": "Bearer \(token )", "X-UP-APP": packageName, "X-UP-PLATFORM": "IOS",  "X-UP-VERSION": buildVersion], parameters: ["package_name": "com.unplugged.messenger", "timestamp": date_st, "subscription_plan": "BASIC"], success: { response in
            MXLog.warning(response.response?.headers)
            MXLog.warning(response.response?.headers["x-up-min-version"] ?? "hhhh")
            if response.response?.statusCode == 200 {
                var minVersion = Int(response.response?.headers["x-up-min-version"] ?? "0")
                var grace_period = Int(response.response?.headers["x-up-grace-period"] ?? "-1")
                let buildVer = Int(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "0") ?? 0

                if buildVer > minVersion ?? 0 {
                    success(-1)

                } else {
                    success(grace_period ?? -1)
                }
                }
                else{
                    success(-1)
                }


        }, failure: { error in
//            print(response)
            print(error.localizedLowercase)
            failure(FailureMessage(error))
        })
    }
    func deactivateUPAccount(success: @escaping (_ result: Bool?) -> Void, failure: @escaping (_ failureMsg: FailureMessage) -> Void) {
//        var headers =
       let token  = UserDefaults.standard.value(forKey: "uptoken") ?? ""
//        MXLog.debug("token==>> \(token)")
//        headers["Authorization"] = "Bearer \(token ?? "")"

        APIManager.shared.callAPI(strURL: (ServerURLs().apiBaseUrl + "accounts/deactivate?erase=true"), queryItems: nil, method: .delete, headers: ["Authorization": "Bearer \(token )"], parameters: [:], success: { response in
            if response.response?.statusCode == 200 {

                    success(true)
                }
                else{
                    success(false)
                }

            MXLog.warning("response-deactivate a/c == \(response)")
        }, failure: { error in
            MXLog.warning("response-deactivate error == \(error)")
            failure(FailureMessage(error))
        })
    }
    func checkUPUsername(username: String, completion: @escaping (_ response:[String : Any]?, _ error: Error?) -> Void){
        let corporateUrl = ServerURLs().apiBaseUrl+"accounts/username-check?username=\(username)"
        NetworkManager().getRequest(url: corporateUrl) { (response, error) in
            completion(response,error)
        }
    }

    func callCreateLogin(queryItems: [URLQueryItem]? = nil, parameters: Parameters? = nil, success: @escaping (_ result: CreateLoginResponse?) -> Void, failure: @escaping (_ failureMsg: FailureMessage) -> Void) {
        var headers = HTTPHeaders()
        headers["content-type"] = "application/json"
        APIManager.shared.callAPI(strURL: ServerURLs().apiBaseUrl+"login", queryItems: queryItems, method: .post, headers: headers, parameters: parameters, success: { response in
            do {

                if let data = response.data {
                    let createLoginResponse = try JSONDecoder().decode(CreateLoginResponse.self, from: data)
                    success(createLoginResponse)

                } else {
                    success(nil)
                }

            } catch {
                failure(FailureMessage(error.localizedDescription))
            }

        }, failure: { error in
            failure(FailureMessage(error))
        })
    }

    func callRegistrationApi(queryItems: [URLQueryItem]? = nil, parameters: Parameters? = nil, success: @escaping (_ result: RegistrationResponse?) -> Void, failure: @escaping (_ failureMsg: FailureMessage) -> Void) {
        var headers = HTTPHeaders()
        headers["content-type"] = "application/json"
//        var defaultHeaders = [String : String]()
//        var headers: [String: String] = [:]
        APIManager.shared.callAPI(strURL: ServerURLs().apiBaseUrl+"sign-up", queryItems: queryItems, method: .post, headers: headers, parameters: parameters, success: { response in
            do {
//                print("dfdf")

                if let data = response.data {
                    let signupResponse = try JSONDecoder().decode(RegistrationResponse.self, from: data)
                    success(signupResponse)

                }
            } catch {
                failure(FailureMessage(error.localizedDescription))
            }

        }, failure: { error in
            failure(FailureMessage(error))
        })
    }
}
