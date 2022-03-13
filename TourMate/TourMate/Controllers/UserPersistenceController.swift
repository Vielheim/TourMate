//
//  UserPersistenceController.swift
//  TourMate
//
//  Created by Keane Chan on 13/3/22.
//

import Foundation
import FirebaseAuth

struct UserPersistenceController {
    let firebasePersistenceManager = FirebasePersistenceManager<FirebaseAdaptedUser>(
        collectionId: FirebaseConfig.userCollectionId)

    func addUser(_ user: User) async -> (Bool, String) {
        guard let currentUser = Auth.auth().currentUser,
              let email = currentUser.email,
              email == user.email
        else {
            return (false, "User is not logged in")
        }

        let adaptedUser = user.toData()
        return await firebasePersistenceManager.addItem(id: email, item: adaptedUser)
    }

    func deleteUser() async -> (Bool, String) {
        guard let user = Auth.auth().currentUser,
              let email = user.email
        else {
            return (false, "User is not logged in")
        }
        return await firebasePersistenceManager.deleteItem(id: email)
    }

    func getUser() async -> (User?, String) {
        guard let user = Auth.auth().currentUser,
              let email = user.email
        else {
            return (nil, "User is not logged in")
        }
        let (adaptedUser, errorMessage) = await firebasePersistenceManager.fetchItem(id: email)
        return (adaptedUser?.toItem(), errorMessage)
    }

}

extension User {
    fileprivate func toData() -> FirebaseAdaptedUser {
        FirebaseAdaptedUser(id: email, name: name, email: email, password: password)
    }
}

extension FirebaseAdaptedUser {
    fileprivate func toItem() -> User {
        User(name: name, email: email, password: password)
    }
}