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

struct RegisterView: View {

    @StateObject var registerViewModel = RegisterViewModel()

    var body: some View {
        ZStack{
            Color("BgColor")
                    .edgesIgnoringSafeArea(.vertical)
            ScrollView{
            VStack(alignment: .leading) {
            Text("Register")
            .font(.largeTitle)
            .foregroundColor(Color("SColor"))
            .padding(.bottom, 10)
//                Button { viewModel.send(viewAction: .login) } label: {
//                    Text(VectorL10n.onboardingSplashLoginButtonTitle)
//                }
            Group {
                Text("First Name")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.white)
                TextField("Enter", text: $registerViewModel.fname)
                        .padding()
                .frame(height: 44).background(Color.black)
                .foregroundColor(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white, lineWidth: 1)
                ).padding(.all, 2)

                Text("Last Name")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.white)
                TextField("Enter", text: $registerViewModel.lname)
                        .padding()
                .frame(height: 44).background(Color.black)
                .foregroundColor(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white, lineWidth: 1)
                ).padding(.all, 2)

                Text("Username")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.white)
                TextField("Enter", text: $registerViewModel.username)
                    .padding(.horizontal, 5)
                .frame(height: 44).background(Color.black)
                .foregroundColor(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white, lineWidth: 1)
                ).padding(.all, 2)


                Text("Email")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.white)
                TextField("Enter", text: $registerViewModel.email)
                    .padding(.horizontal, 5)
                .frame(height: 44).background(Color.black)
                .foregroundColor(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white, lineWidth: 1)
                ).padding(.all, 2)

                Text("Phone Number")
                .font(.title3)
                .fontWeight(.medium)
                .foregroundColor(Color.white)
                TextField("Enter", text: $registerViewModel.phone)
                    .padding(.horizontal, 5)
                .frame(height: 44).background(Color.black)
                .foregroundColor(Color.white)
                .overlay(RoundedRectangle(cornerRadius: 6).stroke(Color.white, lineWidth: 1)
                ).padding(.all, 2)

                }
            Text("Password")
            .font(.title3)
            .fontWeight(.medium)
            .foregroundColor(Color.white)
            SecureField("Password", text: $registerViewModel.password)
                    .padding().frame(height: 44).background(Color.black)
                    .foregroundColor(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white, lineWidth: 1)
            ).padding(.all, 2)

            SecureField("Confirm Password", text: $registerViewModel.confirmpassword)
                    .padding().frame(height: 44).background(Color.black)
                    .foregroundColor(Color.white)
            .overlay(RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.white, lineWidth: 1)
            ).padding(.all, 2)
//                PrimaryButton(title: "Sign Up").onTapGesture {
//                    let createLoginRequest = RegistrationRequest(username: registerViewModel.username, password: registerViewModel.password, firstName: registerViewModel.fname, lastName: registerViewModel.lname, email: registerViewModel.email, phoneNumber: registerViewModel.phone)
//                    registerViewModel.createSignup(request: createLoginRequest)
//                }
                Spacer()

        }.padding()
        }
        }
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
