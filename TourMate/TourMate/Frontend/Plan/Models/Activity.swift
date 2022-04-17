//
//  Activity.swift
//  TourMate
//
//  Created by Tan Rui Quan on 8/4/22.
//

import Foundation

class Activity: Plan {
    var location: Location

    override var locations: [Location] {
        [ location ]
    }

    init(plan: Plan, location: Location) {
        self.location = location
        super.init(plan: plan)
    }

    // All fields
    init(id: String, tripId: String, name: String,
         startDateTime: DateTime,
         endDateTime: DateTime,
         imageUrl: String = "",
         status: PlanStatus,
         creationDate: Date,
         modificationDate: Date,
         additionalInfo: String = "",
         ownerUserId: String,
         modifierUserId: String,
         versionNumber: Int,
         location: Location) {
        self.location = location

        super.init(id: id, tripId: tripId, name: name,
                   startDateTime: startDateTime,
                   endDateTime: endDateTime,
                   imageUrl: imageUrl,
                   status: status,
                   creationDate: creationDate,
                   modificationDate: modificationDate,
                   additionalInfo: additionalInfo,
                   ownerUserId: ownerUserId,
                   modifierUserId: modifierUserId,
                   versionNumber: versionNumber)
    }

    override func equals<T>(other: T) -> Bool where T: Plan {
        guard super.equals(other: other),
              let otherActivity = other as? Activity
        else {
            return false
        }

        return location == otherActivity.location
    }

    override func diff<T>(other: T) -> PlanDiffMap where T: Plan {
        var diffMap = super.diff(other: other)

        guard let otherActivity = other as? Activity else {
            return diffMap
        }

        addDifference(diffMap: &diffMap, name: "Location", item1: location,
                      item2: otherActivity.location)

        return diffMap
    }

    override var description: String {
        "(Activity: \(super.description))"
    }
}
