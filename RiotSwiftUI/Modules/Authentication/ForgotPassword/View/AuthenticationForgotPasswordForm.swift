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

/// The form shown to enter an email address.
struct AuthenticationForgotPasswordForm: View {
    
    // MARK: - Properties
    
    // MARK: Private
    
    @Environment(\.theme) private var theme
    
    @State private var isEditingTextField = false
    
    // MARK: Public
    
    @ObservedObject var viewModel: AuthenticationForgotPasswordViewModel.Context
    
    // MARK: Views
    
    var body: some View {
        VStack(spacing: 0) {
            header
                .padding(.top, OnboardingMetrics.topPaddingToNavigationBar)
                .padding(.bottom, 36)
            
            mainContent
        }
    }
    
    /// The title, message and icon at the top of the screen.
    var header: some View {
        VStack(spacing: 8) {
//            OnboardingIconImage(image: Asset.Images.splashLogo)
//                .padding(.bottom, 8)
            
            Text("Password Reset")
                .font(theme.fonts.title2B)
                .multilineTextAlignment(.center)
                .foregroundColor(theme.colors.primaryContent)
                .accessibilityIdentifier("titleLabel")
            
//            Text(viewModel.viewState.formHeaderMessage)
//                .font(theme.fonts.body)
//                .multilineTextAlignment(.center)
//                .foregroundColor(theme.colors.secondaryContent)
//                .accessibilityIdentifier("messageLabel")
        }
    }
    
    /// The text field and submit button where the user enters an email address.
    var mainContent: some View {
        VStack(alignment: .leading, spacing: 12) {
            if #available(iOS 15.0, *) {
                textField
                    .onSubmit(submit)
            } else {
                textField
            }
            
            Button(action: submit) {
                Text(VectorL10n.submit)
            }
            .buttonStyle(PrimaryActionButtonStyle(customColor: Color("SColor"), customtextColor: Color.black))
            .disabled(viewModel.viewState.hasInvalidAddress)
            .accessibilityIdentifier("nextButton")

        }
    }
    
    /// The text field, extracted for iOS 15 modifiers to be applied.
    var textField: some View {
        UPRoundedBorderTextField(title: "Username", placeHolder:"john.doe", text: $viewModel.emailAddress, configuration: UIKitTextInputConfiguration(autocapitalizationType: .none, autocorrectionType: .no))
//        {
//            isEditingTextField = $0
//        }
        .textFieldStyle(BorderedInputFieldStyle(isEditing: isEditingTextField, isError: false))
        .keyboardType(.emailAddress)
        .autocapitalization(.none)
        .disableAutocorrection(true)
        .accessibilityIdentifier("addressTextField")
    }
    
    /// Sends the `send` view action so long as a valid email address has been input.
    func submit() {
        guard !viewModel.viewState.hasInvalidAddress else { return }
        viewModel.send(viewAction: .send)
    }
}
