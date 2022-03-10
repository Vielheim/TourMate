//
//  TourMateApp.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/3/22.
//

import SwiftUI

@main
struct TourMateApp: App {
    @StateObject private var model = MockModel()

    var body: some Scene {
        WindowGroup {
            LaunchView()
//            ContentView()
//                .environmentObject(model)
        }
    }
}
