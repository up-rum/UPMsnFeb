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

struct LoginView: View {
//    @StateObject var loginViewModel = LoginViewModel()
    @ObservedObject var viewModel: LoginViewModel.Context
//    @EnvironmentObject var authentication: Authentication
    var body: some View {
        ZStack() {
            Color("BgColor")
                    .edgesIgnoringSafeArea(.all)

//            VStack() {
//
//                Image(uiImage: #imageLiteral(resourceName: "uplogo"))
//            }.padding(.top, 0)


                VStack(alignment: .leading) {Text("SIGN IN")
                .font(.largeTitle)
                .foregroundColor(Color("SColor"))


//                    TextField("Username", text: $loginViewModel.username)
//                        .padding()
//                .frame(height: 42).background(Color.black)
//                .foregroundColor(Color.white)
//                .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.white, lineWidth: 1)
//                ).padding(.all, 5)

//                    Text(self.loginViewModel.usernameErrorMsg).padding().foregroundColor(Color.red).font(.system(size: 10)).autocapitalization(.none)

//            SecureField("Password", text: $loginViewModel.password).frame(height: 42).background(Color.black)
//                        .foregroundColor(Color.white).autocapitalization(.none)
//                .overlay(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .stroke(Color.white, lineWidth: 1)
//                ).padding(.all, 5)

//                    Text(self.loginViewModel.passwordErrorMsg).foregroundColor(Color.red).font(.system(size: 10))
//            if $loginViewModel.showProgressView {
//                ProgressView()
//            }
                    Button("Sign In", action: {
//                        let createLoginRequest = CreateLoginRequest(username: loginViewModel.username, password: loginViewModel.password)
//                        loginViewModel.createLogin(request: createLoginRequest)
                    }).buttonStyle(PrimaryActionButtonStyle())
//                        .disabled(loginViewModel.canSuibmit)
                    Button { viewModel.send(viewAction: .login) } label: {
                        Text(VectorL10n.onboardingSplashLoginButtonTitle)
                    }
//                    PrimaryButton(title: "Sign In").onTapGesture {
//                        let createLoginRequest = CreateLoginRequest(username: loginViewModel.username, password: loginViewModel.password)
//                        loginViewModel.createLogin(request: createLoginRequest)
//                    }
                    Spacer()
                }.padding()
        }

    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView(viewModel: LoginViewModel.Context)
//    }
//}
