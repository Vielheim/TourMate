//
//  PlanHeaderView.swift
//  Tourmate
//
//  Created by Rayner Lim on 9/3/22.
//

import SwiftUI

struct PlanHeaderView: View {
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

struct PlanHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        PlanHeaderView(date: Date(timeIntervalSince1970: 1651442400),
                       timeZone: TimeZone(abbreviation: "PST")!)
    }
}
