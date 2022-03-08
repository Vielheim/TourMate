//
//  LaunchView.swift
//  TourMate
//
//  Created by Terence Ho on 8/3/22.
//

import SwiftUI

struct LaunchView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                HStack(spacing: 0.0) {
                    Text("Tour")
                        .font(.system(size: 64))
                        .foregroundColor(.blue)

                    Text("Mate")
                        .font(.system(size: 64))
                        .foregroundColor(.teal)
                }
                .padding()

                Text("Planning your next trip has never been easier")
                    .foregroundColor(.blue)

                Spacer()

                Button(action: onLogInButtonPressed) {
                    Text("Log In")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding()
                }
                .frame(maxWidth: geometry.size.width / 5.0)
                .background(.blue)
                .cornerRadius(20)
                .shadow(color: .gray, radius: 5.0, x: 3.0, y: 4.0)
                .padding()

                Button(action: onRegisterButtonPressed) {
                    Text("Don't have an account? Register here!")
                        .foregroundColor(.blue)
                        .underline()
                }

                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
    }

    private func onLogInButtonPressed() {

    }

    private func onRegisterButtonPressed() {

    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
