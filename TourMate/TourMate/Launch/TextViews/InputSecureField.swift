//
//  SecureInputField.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import SwiftUI

// When we toggle from Secure > Text > Secure
// Typing in a new text will replace the current text
// This is a design of SecureField by Apple
struct InputSecureField: View {

    var title: String
    @Binding var textField: String

    @State var showText = false

    var showTextImageName: String {
        if self.showText {
            return "eye"
        } else {
            return "eye.slash"
        }
    }

    var showTextImageAccentColor: Color {
        if self.showText {
            return .red
        } else {
            return .gray
        }
    }

    var body: some View {
        ZStack(alignment: .trailing) {
            if showText {
                InputTextField(title: title, textField: $textField)
            } else {
                SecureField(title, text: $textField)
                    .padding()
                    .background(.thinMaterial)
                    .cornerRadius(10.0)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .keyboardType(.default)
            }

            Button(action: showTextToggle) {
                Image(systemName: showTextImageName)
                    .accentColor(showTextImageAccentColor)
                    .padding()
                    .background(.ultraThinMaterial)
            }
        }
    }

    private func showTextToggle() {
        showText.toggle()
    }
}

struct SecureInputField_Previews: PreviewProvider {
    static var previews: some View {
        InputSecureField(title: "Password", textField: LogInView().$password)
    }
}
