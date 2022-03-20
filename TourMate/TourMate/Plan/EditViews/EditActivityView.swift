//
//  EditActivityView.swift
//  TourMate
//
//  Created by Terence Ho on 20/3/22.
//

import SwiftUI

struct EditActivityView: View {

    @Environment(\.dismiss) var dismiss

    @StateObject var viewModel = EditPlanViewModel()

    let activity: Activity

    @State private var isConfirmed = true
    @State private var eventName = ""
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var venue = ""
    @State private var address = ""
    @State private var phone = ""
    @State private var website = ""

    init(activity: Activity) {
        self.activity = activity
        self._isConfirmed = State(initialValue: activity.status == .confirmed ? true : false)
        self._eventName = State(initialValue: activity.name)
        self._startDate = State(initialValue: activity.startDate)
        self._endDate = State(initialValue: activity.endDate)
        self._venue = State(initialValue: activity.venue ?? "")
        self._address = State(initialValue: activity.address ?? "")
        self._phone = State(initialValue: activity.phone ?? "")
        self._website = State(initialValue: activity.website ?? "")
    }

    private func createUpdatedActivity() -> Activity {
        let timeZone = TimeZone.current
        let status = isConfirmed ? PlanStatus.confirmed : PlanStatus.proposed
        let modificationDate = Date()
        let activity = Activity(id: activity.id,
                                tripId: activity.tripId,
                                name: eventName,
                                startDate: startDate,
                                endDate: endDate,
                                startTimeZone: timeZone,
                                status: status,
                                creationDate: activity.creationDate,
                                modificationDate: modificationDate,
                                venue: venue,
                                address: address,
                                phone: phone,
                                website: website)
        return activity
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.hasError {
                    Text("Error occured")
                } else {
                    Form {
                        Toggle("Confirmed?", isOn: $isConfirmed)
                        TextField("Event Name", text: $eventName)
                        DatePicker("Start Date",
                                   selection: $startDate,
                                   displayedComponents: [.date, .hourAndMinute])
                        DatePicker("End Date",
                                   selection: $endDate,
                                   displayedComponents: [.date, .hourAndMinute])
                        TextField("Venue", text: $venue)
                        TextField("Address", text: $address)
                        TextField("Phone", text: $phone)
                        TextField("Website", text: $website)
                    }
                    .navigationTitle("Edit Activity")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                Task {
                                    await viewModel.updatePlan(plan: createUpdatedActivity())
                                    dismiss()
                                }
                            }
                            .disabled(viewModel.isLoading || viewModel.hasError)
                        }
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel", role: .destructive) {
                                dismiss()
                            }
                            .disabled(viewModel.isLoading)
                        }
                        ToolbarItem(placement: .bottomBar) {
                            Button("Delete Trip", role: .destructive) {
                                Task {
                                    await viewModel.deletePlan(plan: createUpdatedActivity())
                                    dismiss()
                                }
                            }
                            .disabled(viewModel.isLoading || viewModel.hasError)
                        }
                    }
                }
            }
        }
    }
}

// struct EditActivityView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditActivityView()
//    }
// }
