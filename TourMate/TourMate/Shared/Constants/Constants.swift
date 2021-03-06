//
//  Constants.swift
//  TourMate
//
//  Created by Keane Chan on 14/3/22.
//

final class Constants {
    private init() {}

    static let messageUserNotLoggedIn = "User is not logged in"

    static let errorTripConversion = "[FirebaseTripService] Error converting"
    + "FirebaseAdaptedData into FirebaseAdaptedTrip"

    static let errorPlanConversion = "[FirebasePlanService] Error converting"
    + "FirebaseAdaptedData to FirebaseAdaptedPlan"

    static let errorCommentConversion = "[FirebaseCommentService] Error converting"
    + "FirebaseAdaptedData to FirebaseAdaptedComment"

    static let errorPlanUpvoteConversion = "[FirebasePlanUpvoteService] Error converting"
    + "FirebaseAdaptedData to FirebaseAdaptedPlanUpvote"
}
