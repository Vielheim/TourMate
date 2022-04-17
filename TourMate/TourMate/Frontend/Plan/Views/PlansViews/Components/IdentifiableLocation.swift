//
//  IdentifiableLocation.swift
//  TourMate
//
//  Created by Terence Ho on 17/4/22.
//

import Foundation
import SwiftUI
import MapKit

struct IdentifiableLocation: Identifiable {
    var id: Int
    var coordinate: CLLocationCoordinate2D
    var status: PlanStatus
}
