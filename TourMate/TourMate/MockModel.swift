//
//  MockModel.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import Foundation

struct Trip {
    var id: Int
    var name: String
    var imageUrl: String
    var plans: [Plan]
}

struct Plan {
    var id: Int
    var name: String
    var startDate: Date
    var endDate: Date?
    var timeZone: TimeZone
    var imageUrl: String
}

final class MockModel: ObservableObject {
    @Published var trips: [Trip]

    init() {
        let plans: [Plan] = [
            Plan(id: 0,
                 name: "Visit Venice Beach",
                 startDate: Date(timeIntervalSince1970: 1651442400),
                 endDate: Date(timeIntervalSince1970: 1651453200),
                 timeZone: TimeZone(abbreviation: "PST")!,
                 imageUrl: "https://source.unsplash.com/qxstzQ__HMk"),
            Plan(id: 1,
                 name: "Dinner at Spago",
                 startDate: Date(timeIntervalSince1970: 1651460400),
                 endDate: Date(timeIntervalSince1970: 1651467600),
                 timeZone: TimeZone(abbreviation: "PST")!,
                 imageUrl: "https://source.unsplash.com/pT0qBgNa0VU"),
            Plan(id: 2,
                 name: "Visit Grand Canyon",
                 startDate: Date(timeIntervalSince1970: 1651475400),
                 timeZone: TimeZone(abbreviation: "MST")!,
                 imageUrl: "https://source.unsplash.com/pT0qBgNa0VU")
        ]

        self.trips = [
            Trip(id: 0,
                 name: "West Coast Summer",
                 imageUrl: "https://source.unsplash.com/qxstzQ__HMk",
                 plans: plans),
            Trip(id: 1,
                 name: "Winter in Japan",
                 imageUrl: "https://source.unsplash.com/pT0qBgNa0VU",
                 plans: plans)
        ]
    }

}
