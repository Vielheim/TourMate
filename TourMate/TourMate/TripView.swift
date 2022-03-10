//
//  TripDetailView.swift
//  Tourmate
//
//  Created by Rayner Lim on 7/3/22.
//

import SwiftUI

struct TripView: View {
    @EnvironmentObject var model: MockModel
    @State var id: Int

    var body: some View {
        let trip = model.trips[id]

        return TabView {
            ItineraryView(id: id)
                .tabItem {
                    Image(systemName: "menucard.fill")
                    Text("Itinerary")
                }
            PackingListView()
                .tabItem {
                    Image(systemName: "list.bullet.rectangle.portrait.fill")
                    Text("Packing List")
                }
        }
        .navigationTitle(trip.name)
    }
}

struct TripView_Previews: PreviewProvider {
    static var previews: some View {
        TripView(id: 0).environmentObject(MockModel())
    }
}
