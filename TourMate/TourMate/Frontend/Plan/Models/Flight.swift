//
//  Flight.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Flight: Plan {
    let planType: PlanType = .flight

    var id: String
    var tripId: String
    var name: String = "Flight"
    var startDate: Date
    var endDate: Date
    var startTimeZone: TimeZone
    var endTimeZone: TimeZone?
    var imageUrl: String?
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var airline: String?
    var flightNumber: String?
    var seats: String?
    var departureLocation: String?
    var departureTerminal: String?
    var departureGate: String?
    var arrivalLocation: String?
    var arrivalTerminal: String?
    var arrivalGate: String?
}