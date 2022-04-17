//
//  IdentifiablePlan.swift
//  TourMate
//
//  Created by Terence Ho on 17/4/22.
//

import Foundation

struct IdentifiablePlan: Identifiable, Equatable {
    static func == (lhs: IdentifiablePlan, rhs: IdentifiablePlan) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let plan: Plan
}
