//
//  PlanHeaderView.swift
//  Tourmate
//
//  Created by Rayner Lim on 9/3/22.
//

import SwiftUI

struct PlanDateView: View {
    let date: Date
    let dateFormatter: DateFormatter

    init(date: Date, timeZone: TimeZone) {
        self.date = date
        self.dateFormatter = DateFormatter()
        // self.dateFormatter.setLocalizedDateFormatFromTemplate("EEE d MMM yyyy")
        self.dateFormatter.dateStyle = .full
        self.dateFormatter.timeZone = timeZone
    }

    var dateString: String {
        dateFormatter.string(from: date)
    }

    var body: some View {
        Text(dateString)
            .font(.subheadline)
    }
}

struct PlanDateView_Previews: PreviewProvider {
    static var previews: some View {
        PlanDateView(date: Date(timeIntervalSince1970: 1_651_442_400),
                     timeZone: TimeZone(abbreviation: "PST")!)
    }
}
