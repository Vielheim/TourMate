//
//  PlanView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlanView: View {
    let title: String
    let startDate: Date
    let endDate: Date?
    let dateFormatter: DateFormatter

    init(title: String, startDate: Date, endDate: Date? = nil, timeZone: TimeZone) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .full
        self.dateFormatter.timeStyle = .full
        self.dateFormatter.timeZone = timeZone
    }

    var startTimeString: String {
        dateFormatter.string(from: startDate)
    }

    var endTimeString: String? {
        guard let endDate = endDate else {
            return nil
        }
        return dateFormatter.string(from: endDate)
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                VStack(alignment: .leading) {
                    Text("From")
                        .font(.caption)
                    Text(startTimeString)
                        .font(.headline)
                }
                Spacer()
            }
            if let endTimeString = endTimeString {
                HStack {
                    VStack(alignment: .leading) {
                        Text("To")
                            .font(.caption)
                        Text(endTimeString)
                            .font(.headline)
                    }
                    Spacer()
                }
            }
            Spacer()
        }
        .padding()
        .navigationTitle(title)
    }
}

struct PlanView_Previews: PreviewProvider {
    static var previews: some View {
        PlanView(title: "Visit Venice Beach",
                 startDate: Date(timeIntervalSince1970: 1651442400),
                 endDate: Date(timeIntervalSince1970: 1651453200),
                 timeZone: TimeZone(abbreviation: "PST")!)
    }
}
