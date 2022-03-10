//
//  LogInView.swift
//  TourMate
//
//  Created by Terence Ho on 10/3/22.
//

import SwiftUI

struct LogInView: View {
    let authenticationController = AuthenticationController()

    @State var username = ""
    @State var password = ""
    @State var pageIsDisabled = false

    var logInButtonDisabled: Bool {
        username.isEmpty || password.isEmpty
    }

    var logInButtonColor: Color {
        if logInButtonDisabled {
            return .gray
        } else {
            return .blue
        }
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                Spacer()

                TitleView()

                Spacer()

                VStack(alignment: .center, spacing: geometry.size.height / 100.0) {

                    InputTextField(title: "Username", textField: $username)

                    InputSecureField(title: "Password", textField: $password)

                    Button(action: onLogInButtonPressed) {
                        Text("Log In")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                    }
                    .frame(maxWidth: geometry.size.width / 5.0)
                    .background(logInButtonColor)
                    .cornerRadius(20)
                    .shadow(color: .gray, radius: 5.0, x: 3.0, y: 4.0)
                    .padding()
                    .disabled(logInButtonDisabled)
                }
                .frame(maxWidth: geometry.size.width / 2.0)

                if pageIsDisabled {
                    ProgressView("Logging In...")
                        .padding()
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func onLogInButtonPressed() {
        guard self.pageIsDisabled == false else {
            return
        }

        self.pageIsDisabled = true
        let inputUsername = username
        let inputPassword = password

        authenticationController.logIn(username: inputUsername, password: inputPassword)

        self.pageIsDisabled = false
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
