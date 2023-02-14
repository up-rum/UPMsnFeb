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

import SwiftUI

struct AuthenticationRegistrationScreen: View {

    // MARK: - Properties
    
    // MARK: Private

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.theme) private var theme: ThemeSwiftUI
    
    @State private var isPasswordFocused = false

    // MARK: Public
    
    @ObservedObject var viewModel: AuthenticationRegistrationViewModel.Context
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                HStack(spacing: 5){
                Button(action: {
                          print("button pressed")
                    self.presentationMode.wrappedValue.dismiss()
                        }) {
                            Image(systemName: "arrow.left")
//                                .frame(width: 30, height: 30)
                                .font(.system(size: 26))
                                .foregroundColor(Color("SColor"))
                                .padding(.trailing, 10)
                        }

                Image("AnalyticsLogo")
                    .resizable()
                    .frame(width: 17,height: 20)
//                    .position(x: 60, y: 30)

                Image("uplogo")
                    .resizable()
                    .frame(width: 127,height: 23)
//                    .position(x: 83, y: 30)

                Spacer()
                Spacer()

                }.padding(.top, 15)


                if viewModel.viewState.homeserver.showRegistrationForm {
                    registrationForm
                }

                if !viewModel.viewState.homeserver.showRegistrationForm && !viewModel.viewState.showSSOButtons {
                    fallbackButton
                }
                
            }
            .readableFrame()
            .padding(.horizontal, 16)
            .padding(.bottom, 16)
        }
        .navigationBarHidden(true)
        .background(Color("BgColor").ignoresSafeArea())
        .alert(item: $viewModel.alertInfo) { $0.alert }
        .accentColor(theme.colors.accent)
        .onTapGesture {

              self.endTextEditing()
        }
    }

    /// The sever information section that includes a button to select a different server.
    var serverInfo: some View {
        AuthenticationServerInfoSection(address: viewModel.viewState.homeserver.address,
                                        flow: .register) {
            viewModel.send(viewAction: .selectServer)
        }
    }
    
    /// The form with text fields for username and password, along with a submit button.
    var registrationForm: some View {
        VStack(spacing: 15) {
            GeometryReader { geometry in

                Text("REGISTER")
                    .font(theme.fonts.largeTitle)
                    .foregroundColor(Color("SColor"))
                    .frame(width:geometry.size.width, alignment: .leading)

            }.padding(.vertical, 25)
            
//            Image(uiImage: #imageLiteral(resourceName: "uplogo"))
//                .resizable()
//                .scaledToFit()
//                .frame(maxWidth: 150) // This value is problematic. 300 results in dropped frames
//                                      // on iPhone 12/13 Mini. 305 the same on iPhone 12/13. As of
//                                      // iOS 15, 310 seems fine on all supported screen widths 🤞.
//                .padding(20)
//                .accessibilityHidden(true)
            UPRoundedBorderTextField(title: "First name",
                                   placeHolder: "John (Optional)",
                                   text: $viewModel.firstName,
//                                   footerText: viewModel.viewState.usernameFooterMessage,
//                                   isError: viewModel.viewState.hasEditedUsername && viewModel.viewState.isUsernameInvalid,
                                   isFirstResponder: false,
                                   configuration: UIKitTextInputConfiguration(returnKeyType: .next,
                                                                              autocapitalizationType: .words,
                                                                              autocorrectionType: .no),
//                                     onEditingChanged: rebuildUsername,
                                   onCommit: { isPasswordFocused = true })
            .onChange(of: viewModel.lastName) { _ in viewModel.send(viewAction: .rebuildUsername) }
            .accessibilityIdentifier("fNameTecallxtField")

            UPRoundedBorderTextField(title: "Last name",
                                   placeHolder: "Doe (Optional)",
                                   text: $viewModel.lastName,
//                                   footerText: viewModel.viewState.usernameFooterMessage,
//                                   isError: viewModel.viewState.hasEditedUsername && viewModel.viewState.isUsernameInvalid,
                                   isFirstResponder: false,
                                   configuration: UIKitTextInputConfiguration(returnKeyType: .next,
                                                                              autocapitalizationType: .words,
                                                                              autocorrectionType: .no),
//                                   onEditingChanged: rebuildUsername,
                                   onCommit: { isPasswordFocused = true })
            .onChange(of: viewModel.lastName) { _ in viewModel.send(viewAction: .rebuildUsername) }
            .accessibilityIdentifier("lNameTextField")

            UPRoundedBorderTextField(title: "Username*",
                                   placeHolder: "john.doe",
                                     text: $viewModel.username,
                                     footerText: viewModel.viewState.usernameFooterMessage == "" ? nil : viewModel.viewState.usernameFooterMessage,

                                   isError: viewModel.viewState.hasEditedUsername && viewModel.viewState.isUsernameInvalid,

                                   isFirstResponder: false,
                                   configuration: UIKitTextInputConfiguration(returnKeyType: .next,
                                                                              autocapitalizationType: .none,
                                                                              autocorrectionType: .no),
                                     tfCharValidation: "username",
                                   onEditingChanged: usernameEditingChanged,

                                   onCommit: { isPasswordFocused = true })
            .onChange(of: viewModel.username) { _ in viewModel.send(viewAction: .resetUsernameAvailability) }
            .accessibilityIdentifier("usernameTextField")

            UPRoundedBorderTextField(title: "Email*",
                                   placeHolder: "johndoe@unplugged.com",
                                   text: $viewModel.email,
//                                   footerText: viewModel.viewState.usernameFooterMessage,
//                                   isError: viewModel.viewState.hasEditedUsername && viewModel.viewState.isUsernameInvalid,
                                   isFirstResponder: false,
                                   configuration: UIKitTextInputConfiguration(keyboardType: .emailAddress, returnKeyType: .next,
                                                                              autocapitalizationType: .none,
                                                                              autocorrectionType: .no),
                                     tfCharValidation: "email",
//                                   onEditingChanged: usernameEditingChanged,
                                   onCommit: { })

            .accessibilityIdentifier("upemailTextField")

            UPRoundedBorderTextField(title: "Phone number",
                                   placeHolder: "1-000-000-000 (Optional)",
                                   text: $viewModel.phoneNumber,
//                                   footerText: viewModel.viewState.usernameFooterMessage,
//                                   isError: viewModel.viewState.hasEditedUsername && viewModel.viewState.isUsernameInvalid,
//                                   isFirstResponder: false,
                                     configuration: UIKitTextInputConfiguration(keyboardType: .numberPad, returnKeyType: .next, autocapitalizationType: .none, autocorrectionType: .no),
                                     
//                                   onEditingChanged: usernameEditingChanged,
                                   onCommit: { })

            .accessibilityIdentifier("phoneTextField")
            
            UPRoundedBorderTextField(title: "Select password*",
                                   placeHolder: "Password",
                                   text: $viewModel.password,
//                                   footerText: VectorL10n.authenticationRegistrationPasswordFooter,
                                   isError: viewModel.viewState.hasEditedPassword && viewModel.viewState.isPasswordInvalid,
                                   isFirstResponder: isPasswordFocused,
                                   configuration: UIKitTextInputConfiguration(returnKeyType: .done,
                                                                              isSecureTextEntry: true),
                                   onEditingChanged: passwordEditingChanged,
                                   onCommit: submit)
            .accessibilityIdentifier("passwordTextField")

            UPRoundedBorderTextField(title: nil,
                                   placeHolder: "Confirm password",
                                   text: $viewModel.confirmPassword,
                                     footerText: viewModel.viewState.confirmPasswordFooterMessage,
                                     isError: viewModel.viewState.passwordNotMatched,
//                                   isFirstResponder: isPasswordFocused,
                                   configuration: UIKitTextInputConfiguration(returnKeyType: .done,
                                                                              isSecureTextEntry: true),
                                   onEditingChanged: passwordEditingChanged,
                                   onCommit: submit)
            .accessibilityIdentifier("passwordTextField")

           Group{
               CheckboxField(id: "accept", label: "I accept", isMarked: $viewModel.acceptTerms)

            CheckboxField1(id: "subscribe", label: "Subscribe to Email Updates & Privacy Tips", isMarked: $viewModel.subscribeEmailUpdates)

           }
            Button(action: submit) {
                Text("REGISTER")
            }
            .buttonStyle(PrimaryActionButtonStyle(customColor: Color("SColor"), customtextColor: Color.black))
            .disabled(!viewModel.viewState.canSubmit)
            .accessibilityIdentifier("nextButton")
        }
    }
    
    /// A list of SSO buttons that can be used for login.
    var ssoButtons: some View {
        VStack(spacing: 16) {
            ForEach(viewModel.viewState.homeserver.ssoIdentityProviders) { provider in
                AuthenticationSSOButton(provider: provider) {
                    viewModel.send(viewAction: .continueWithSSO(provider))
                }
                .accessibilityIdentifier("ssoButton")
            }
        }
    }

    /// A fallback button that can be used for login.
    var fallbackButton: some View {
        Button(action: fallback) {
            Text(VectorL10n.authRegister)
        }
        .buttonStyle(PrimaryActionButtonStyle())
        .accessibilityIdentifier("fallbackButton")
    }
    
    /// Validates the username when the text field ends editing.
    func usernameEditingChanged(isEditing: Bool) {
        guard !isEditing, !viewModel.username.isEmpty else { return }
        viewModel.send(viewAction: .validateUsername)
    }
    func rebuildUsername(isEditing: Bool) {
//        guard !isEditing, !viewModel.fi.isEmpty else { return }
        viewModel.username = viewModel.firstName + "." + viewModel.lastName
//        viewModel.send(viewAction: .validateUsername)
    }
    /// Enables password validation the first time the user finishes editing.
    /// Additionally resets the password field focus.
    func passwordEditingChanged(isEditing: Bool) {
        guard !isEditing else { return }
        isPasswordFocused = false
        
        guard !viewModel.viewState.hasEditedPassword else { return }
        viewModel.send(viewAction: .enablePasswordValidation)
    }

    
    
    /// Sends the `next` view action so long as valid credentials have been input.
    func submit() {
        self.endTextEditing()
        guard viewModel.viewState.canSubmit else { return }
        viewModel.send(viewAction: .next)
    }

    /// Sends the `fallback` view action.
    func fallback() {
        viewModel.send(viewAction: .fallback)
    }
}

// MARK: - Previews

@available(iOS 15.0, *)
struct AuthenticationRegistration_Previews: PreviewProvider {
    static let stateRenderer = MockAuthenticationRegistrationScreenState.stateRenderer
    static var previews: some View {
        stateRenderer.screenGroup(addNavigation: true)
            .navigationViewStyle(.stack)
    }
}
struct CheckboxField: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int

    @Binding var isMarked: Bool /// Binding here!

    init(
    id: String,
    label:String,
    size: CGFloat = 14,
    color: Color = Color("SColor"),
    textSize: Int = 14,
    isMarked: Binding<Bool>
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self._isMarked = isMarked /// to init, you need to add a _
    }


    var body: some View {
        Button(action:{
            self.isMarked.toggle() /// just toggle without closure
        })
        {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square.fill" : "square")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                Text(label)
                .font(Font.system(size: size))
                .foregroundColor(Color.white.opacity(0.87))
                Link("Term and Conditions", destination: URL(string: "https://unplugged.com/tos")!)
                    .font(Font.system(size: size))
                    .offset(x: -6)
//                Button {
//                    print("Terms & Conditions")
//                } label: {
//                    Text("Terms & Conditions").font(Font.system(size: size))
//                            }
                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}
struct CheckboxField1: View {
    let id: String
    let label: String
    let size: CGFloat
    let color: Color
    let textSize: Int

    @Binding var isMarked: Bool /// Binding here!

    init(
    id: String,
    label:String,
    size: CGFloat = 14,
    color: Color = Color("SColor"),
    textSize: Int = 14,
    isMarked: Binding<Bool>
    ) {
        self.id = id
        self.label = label
        self.size = size
        self.color = color
        self.textSize = textSize
        self._isMarked = isMarked /// to init, you need to add a _
    }


    var body: some View {
        Button(action:{
            self.isMarked.toggle() /// just toggle without closure
        }) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: self.isMarked ? "checkmark.square.fill" : "square")
                .renderingMode(.template)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 20, height: 20)
                Text(label)
                .font(Font.system(size: size))
                .foregroundColor(Color.white.opacity(0.87))

                Spacer()
            }.foregroundColor(self.color)
        }
        .foregroundColor(Color.white)
    }
}
struct CheckboxToggleStyle: ToggleStyle {
    var isReversed = false
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if !isReversed {
                configuration.label
            }
            Button {
                configuration.isOn.toggle()
            } label: {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            }
            .foregroundColor(Color("SColor"))
            .padding(5)
            .font(.title3)
            .accentColor(Color(UIColor.label))
            if isReversed {
                configuration.label
            }
        }
    }
}

struct CheckboxToggleStyle2: ToggleStyle {
    var isReversed = false
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            if !isReversed {
                configuration.label
            }
            Button {
                configuration.isOn.toggle()
            } label: {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
            }
            .foregroundColor(Color("SColor"))
            .padding(5)
            .font(.title3)
            .accentColor(Color(UIColor.label))
            if isReversed {
                configuration.label
            }
//            Text("I accept").foregroundColor(.white)
            Button {
                print("Terms & Conditions")
            } label: {
                Text("Terms & Conditions").font(.title3)
                        }
        }
    }
}
extension View {
  func endTextEditing() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                    to: nil, from: nil, for: nil)
  }
}
