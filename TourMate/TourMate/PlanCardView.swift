//
//  PlanCardView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct PlanCardView: View {
    let title: String
    let startDate: Date
    let endDate: Date?
    let dateFormatter: DateFormatter

    init(title: String, startDate: Date, endDate: Date? = nil, timeZone: TimeZone) {
        self.title = title
        self.startDate = startDate
        self.endDate = endDate
        self.dateFormatter = DateFormatter()
        self.dateFormatter.timeStyle = .short
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
        HStack {
            VStack(alignment: .leading) {
                HStack(spacing: 0) {
                    Text(startTimeString)
                        .font(.caption)
                    if let endTimeString = endTimeString {
                        Text(" - " + endTimeString)
                            .font(.caption)
                    }
                }
                Text(title)
                    .font(.headline)
            }
            .padding()
            Spacer()
        }
        .background(RoundedRectangle(cornerRadius: 16)
                        .fill(Color.primary.opacity(0.1)))
    }
}

struct PlanCardView_Previews: PreviewProvider {
    static var previews: some View {
        PlanCardView(title: "Visit Venice Beach",
                     startDate: Date(timeIntervalSince1970: 1651442400),
                     endDate: Date(timeIntervalSince1970: 1651453200),
                     timeZone: TimeZone(abbreviation: "PST")!)
    }
}
