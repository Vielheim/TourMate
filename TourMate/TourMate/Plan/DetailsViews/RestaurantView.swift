//
//  RestaurantView.swift
//  TourMate
//
//  Created by Tan Rui Quan on 19/3/22.
//

import SwiftUI

struct RestaurantView: View {
    @StateObject var restaurantViewModel: PlanViewModel<Restaurant>
    @State private var isShowingEditPlanSheet = false

    @Environment(\.dismiss) var dismiss

    func getDateString(_ date: Date) -> String {
        guard let restaurant = restaurantViewModel.plan else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .full
        dateFormatter.timeZone = restaurant.startTimeZone
        return dateFormatter.string(from: date)
    }

    var body: some View {
        if restaurantViewModel.hasError {
            Text("Error occurred")
        } else {
            HStack {
                if let restaurant = restaurantViewModel.plan {
                    VStack(alignment: .leading) {
                        // Start time
                        VStack(alignment: .leading) {
                            Text("From")
                                .font(.caption)
                            Text(getDateString(restaurant.startDate))
                                .font(.headline)

                            if let endDate = restaurant.endDate {
                                Text("To")
                                    .font(.caption)
                                Text(getDateString(endDate))
                                    .font(.headline)
                            }
                        }
                        .padding()

                        // Adress
                        if let address = restaurant.address {
                            VStack(alignment: .leading) {
                                Text("Address")
                                    .font(.caption)
                                Text(address)
                            }
                            .padding()
                        }

                        // Phone number
                        if let phone = restaurant.phone {
                            HStack {
                                Image(systemName: "phone.fill")
                                Text(phone)
                            }
                            .padding()
                        }

                        // Website
                        if let website = restaurant.website {
                            HStack {
                                Image(systemName: "globe.americas.fill")
                                Text(website)
                            }
                            .padding()
                        }

                        Spacer()
                    }

                    Spacer()
                }
            }
            .navigationBarTitle(restaurantViewModel.plan?.name ?? "Restaurant")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isShowingEditPlanSheet.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .sheet(isPresented: $isShowingEditPlanSheet) {
                        // Edit Plan
                        // After edit -> fetch Plan
                        // If nothing is fetched -> dismiss this view

                        // on dismiss
                        Task {
                            await restaurantViewModel.fetchPlan()

                            // TODO: UI Fix
                            // There is a lag between setting the plan to nil
                            // And when we dismiss this view
                            // Maybe need to see how to change the logic
                            if restaurantViewModel.plan == nil {
                                dismiss()
                            }
                        }
                    } content: {
                        if let restaurant = restaurantViewModel.plan {
                            EditRestaurantView(restaurant: restaurant)
                        } else {
                            Text("Error")
                        }
                    }
                }
            }
            .task {
                await restaurantViewModel.fetchPlan()
            }
        }
    }
}

// struct RestaurantView_Previews: PreviewProvider {
//    static var previews: some View {
//        RestaurantView()
//    }
// }
