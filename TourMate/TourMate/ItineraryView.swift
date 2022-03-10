//
//  ItineraryView.swift
//  Tourmate
//
//  Created by Rayner Lim on 8/3/22.
//

import SwiftUI

struct ItineraryView: View {
    @EnvironmentObject var model: MockModel
    @State var id: Int

    var dateString: String {
        let trip = model.trips[id]
        let sortedPlans = trip.plans.sorted { (plan1, plan2) in
            plan1.startDate < plan2.startDate
        }
        var startDateString = "Unknown"
        var endDateString = "Unknown"
        if let firstPlan = sortedPlans.first, let lastPlan = sortedPlans.last {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .full
            dateFormatter.timeZone = firstPlan.timeZone
            startDateString = dateFormatter.string(from: firstPlan.startDate)
            dateFormatter.timeZone = lastPlan.timeZone
            endDateString = dateFormatter.string(from: lastPlan.endDate ?? lastPlan.startDate)
        }
        return startDateString + " - " + endDateString
    }

    var body: some View {
        let trip = model.trips[id]

        return ScrollView {
            LazyVStack {
                Text(dateString)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.bottom, .horizontal])

                AsyncImage(url: URL(string: trip.imageUrl)) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200, alignment: .center)
                        .clipped()
                } placeholder: {
                    Color.gray
                }

                PlansListView(id: id)
            }
        }
    }
}

struct ItineraryView_Previews: PreviewProvider {
    static var previews: some View {
        ItineraryView(id: 0).environmentObject(MockModel())
    }
}
