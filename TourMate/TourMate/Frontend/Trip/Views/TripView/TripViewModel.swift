//
//  TripViewModel.swift
//  TourMate
//
//  Created by Rayner Lim on 20/3/22.
//

import Foundation
import Combine

@MainActor
class TripViewModel: ObservableObject {

    @Published private(set) var isLoading = false
    @Published private(set) var isDeleted = false
    @Published private(set) var hasError = false

    @Published var attendees: [User] = []
    @Published var trip: Trip

    private var tripService: TripService
    private let userService: UserService

    init(trip: Trip,
         tripService: TripService = FirebaseTripService(),
         userService: UserService = FirebaseUserService()) {

        self.trip = trip
        self.tripService = tripService
        self.userService = userService
    }

    func fetchTripAndListen() async {
        tripService.tripEventDelegate = self

        self.isLoading = true
        await tripService.fetchTripAndListen(withTripId: trip.id)
    }

    func detachListener() {
        tripService.tripEventDelegate = nil

        self.isLoading = false
        tripService.detachListener()
    }

    func inviteUser(email: String) async {
        self.isLoading = true

        // fetch user
        let (user, userErrorMessage) = await userService.getUser(with: "email", value: email)

        guard userErrorMessage.isEmpty else {
            handleError()
            return
        }

        guard let user = user else { // user not null
            print("Email is incorrect")
            self.isLoading = false
            return
        }

        let userId = user.id

        // fetch trip
        let (tripCopy, tripErrorMessage) = await tripService.fetchTrip(withTripId: trip.id)
        guard tripErrorMessage.isEmpty else {
            handleError()
            return
        }

        guard var tripCopy = tripCopy else {
            handleDeletion()
            return
        }

        // update trip
        guard !tripCopy.attendeesUserIds.contains(userId) else { // user not in trip
            print("[TripViewModel] User already invited")
            self.isLoading = false
            return
        }

        tripCopy.attendeesUserIds.append(userId)

        let (hasUpdated, updateErrorMessage) = await tripService.updateTrip(trip: tripCopy)
        guard hasUpdated, updateErrorMessage.isEmpty else {
            handleError()
            return
        }

        self.isLoading = false
    }

    private func fetchAttendees() async {
        var fetchedAttendees: [User] = []

        for userId in trip.attendeesUserIds {
            let (user, userErrorMessage) = await userService.getUser(with: "id", value: userId)

            guard userErrorMessage.isEmpty else {
                handleError()
                return
            }

            guard let user = user else { // user not null
                print("No user exists with id \(userId)")
                handleError()
                return
            }

            fetchedAttendees.append(user)
        }

        self.attendees = fetchedAttendees
    }
}

// MARK: - TripsEventDelegate
extension TripViewModel: TripEventDelegate {
    func update(trip: Trip?, errorMessage: String) async {
        print("[TripViewModel] Updating Single Trip")

        guard let trip = trip else {
            handleDeletion()
            return
        }

        guard errorMessage.isEmpty else {
            handleError()
            return
        }

        self.trip = trip
        await fetchAttendees()

        self.isLoading = false
    }

    func update(trips: [Trip], errorMessage: String) async {}
}

// MARK: - State changes
extension TripViewModel {
    private func handleDeletion() {
        self.isDeleted = true
        self.isLoading = false
    }

    private func handleError() {
        self.isLoading = false
        self.hasError = true
    }

}
