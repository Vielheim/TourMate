//
//  Transport.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

struct Transport: Plan {
    let planType: PlanType = .transport

    var id: String
    var tripId: String
    var name: String = "Transport"
    var startDate: Date
    var endDate: Date
    var startTimeZone: TimeZone
    var endTimeZone: TimeZone?
    var imageUrl: String
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date

    var departureLocation: String?
    var departureAddress: String?
    var arrivalLocation: String?
    var arrivalAddress: String?
    var vehicleDescription: String?
    var numberOfPassengers: String?
}
