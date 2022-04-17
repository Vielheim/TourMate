//
//  Plan.swift
//  TourMate
//
//  Created by Tan Rui Quan on 10/3/22.
//

import Foundation

typealias PlanDiffMap = [String: (String, String)]

class Plan: CustomStringConvertible {
    var id: String
    var tripId: String
    var name: String
    var startDateTime: DateTime
    var endDateTime: DateTime
    var imageUrl: String
    var status: PlanStatus
    var creationDate: Date
    var modificationDate: Date
    var additionalInfo: String
    var ownerUserId: String
    var modifierUserId: String
    var versionNumber: Int

    var versionedId: String {
        id + "-" + String(versionNumber)
    }

    var locations: [Location] {
        []
    }

    init(plan: Plan) {
        self.id = plan.id
        self.tripId = plan.tripId
        self.name = plan.name
        self.startDateTime = plan.startDateTime
        self.endDateTime = plan.endDateTime
        self.imageUrl = plan.imageUrl
        self.status = plan.status
        self.creationDate = plan.creationDate
        self.modificationDate = plan.modificationDate
        self.additionalInfo = plan.additionalInfo
        self.ownerUserId = plan.ownerUserId
        self.modifierUserId = plan.modifierUserId
        self.versionNumber = plan.versionNumber
    }

    // Plan creation
    init(tripId: String, name: String,
         startDateTime: DateTime, endDateTime: DateTime,
         imageUrl: String, status: PlanStatus,
         additionalInfo: String, ownerUserId: String) {
        self.id = tripId + "-" + UUID().uuidString
        self.tripId = tripId
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.imageUrl = imageUrl
        self.status = status
        self.creationDate = Date()
        self.modificationDate = Date()
        self.additionalInfo = additionalInfo
        self.ownerUserId = ownerUserId
        self.modifierUserId = ownerUserId
        self.versionNumber = 1
    }

    // All fields
    init(id: String, tripId: String, name: String,
         startDateTime: DateTime, endDateTime: DateTime,
         imageUrl: String = "", status: PlanStatus,
         creationDate: Date, modificationDate: Date,
         additionalInfo: String = "",
         ownerUserId: String, modifierUserId: String,
         versionNumber: Int) {
        self.id = id
        self.tripId = tripId
        self.name = name
        self.startDateTime = startDateTime
        self.endDateTime = endDateTime
        self.imageUrl = imageUrl
        self.status = status
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.additionalInfo = additionalInfo
        self.ownerUserId = ownerUserId
        self.modifierUserId = modifierUserId
        self.versionNumber = versionNumber
    }

    func equals<T: Plan>(other: T) -> Bool {
        id == other.id
        && tripId == other.tripId
        && name == other.name
        && startDateTime == other.startDateTime
        && endDateTime == other.endDateTime
        && imageUrl == other.imageUrl
        && status == other.status
        && creationDate == other.creationDate
        && modificationDate == other.modificationDate
        && additionalInfo == other.additionalInfo
        && ownerUserId == other.ownerUserId
        && modifierUserId == other.modifierUserId
        && versionNumber == other.versionNumber
    }

    func diff<T: Plan>(other: T) -> [String: (String, String)] {
        var diffMap: [String: (String, String)] = [:]

        addDifference(diffMap: &diffMap, name: "Name", item1: name, item2: other.name)
        addDifference(diffMap: &diffMap, name: "Status", item1: status, item2: other.status)
        addDifference(diffMap: &diffMap, name: "Start Date", item1: startDateTime, item2: other.startDateTime)
        addDifference(diffMap: &diffMap, name: "End Date", item1: endDateTime, item2: other.endDateTime)
        addDifference(diffMap: &diffMap, name: "Image URL", item1: imageUrl, item2: other.imageUrl)
        addDifference(diffMap: &diffMap, name: "Additional Info", item1: additionalInfo, item2: other.additionalInfo)

        return diffMap
    }

    func addDifference<T: Equatable>(diffMap: inout PlanDiffMap, name: String, item1: T, item2: T) {
        guard item1 != item2 else {
            return
        }

        diffMap[name] = ("\(item1)", "\(item2)")
    }

    var description: String {
        "(id: \(id), name: \(name), version: \(versionNumber))"
    }
}
