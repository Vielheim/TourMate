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
            NavigationView {
                VStack {
                    Spacer()

                    TitleView()

                    Spacer()

                    NavigationLink {
                        LogInView()
                    } label: {
                        Group {
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
                    }

                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Don't have an account? Register here!")
                            .foregroundColor(.blue)
                            .underline()
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
            }
            .navigationViewStyle(.stack)
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView()
    }
}
