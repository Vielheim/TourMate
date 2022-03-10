//
//  TripsView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripsView: View {
    @EnvironmentObject var model: MockModel

    func getDateString(id: Int) -> String {
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
        NavigationView {
            ScrollView {
                LazyVStack {
                    ForEach(model.trips, id: \.id) { trip in
                        NavigationLink {
                            TripView(id: trip.id)
                        } label: {
                            TripCardView(title: trip.name,
                                         subtitle: getDateString(id: trip.id),
                                         imageUrl: trip.imageUrl)
                        }
                    }
                }
            }
            .navigationTitle("Trips")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        print("Add trip unimplemented")
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView().environmentObject(MockModel())
    }
}
