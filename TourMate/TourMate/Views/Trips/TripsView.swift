//
//  TripsView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripsView: View {
    @StateObject var viewModel = TripsViewModel()
    @State private var isShowingAddTripSheet = false

    func getDateString(trip: Trip) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeZone = trip.timeZone
        let startDateString = dateFormatter.string(from: trip.startDate)
        let endDateString = dateFormatter.string(from: trip.endDate)
        return startDateString + " - " + endDateString
    }

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.trips, id: \.id) { trip in
                    NavigationLink {
                        TripView(trip: trip)
                    } label: {
                        TripCard(title: trip.name,
                                 subtitle: getDateString(trip: trip),
                                 imageUrl: trip.imageUrl!)
                    }
                }
            }
        }
        .navigationTitle("Trips")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isShowingAddTripSheet.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .sheet(isPresented: $isShowingAddTripSheet) {
                    Task {
                        await viewModel.fetchTrips()
                    }
                } content: {
                    AddTripView()
                }
            }
        }
        .task {
            await viewModel.fetchTrips()
        }
    }
}

struct TripsView_Previews: PreviewProvider {
    static var previews: some View {
        TripsView(viewModel: TripsViewModel(tripController: MockTripController()))
    }
}
