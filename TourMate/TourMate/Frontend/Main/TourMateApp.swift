//
//  TourMateApp.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/3/22.
//

import SwiftUI
import Firebase

@main
struct TourMateApp: App {
    @StateObject private var authenticationController = FirebaseAuthenticationController.singleton

    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            if authenticationController.userIsLoggedIn {
                ContentView()
            } else {
                LaunchView()
                    .onAppear {
                        authenticationController.checkIfUserIsLoggedIn()
                    }
            }
        }
    }
}