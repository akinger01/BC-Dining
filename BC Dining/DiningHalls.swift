//
//  Dining Halls.swift
//  BC Dining
//
//  Created by Andrew King on 12/2/19.
//  Copyright © 2019 Andrew King. All rights reserved.
//

import Foundation
import Firebase

class DiningHalls {
    var diningArray: [DiningHall] = []
    var db: Firestore!

    
    init() {
        db = Firestore.firestore()
    }
    

    func loadData(completed: @escaping () -> ())  {
        db.collection("dining_halls").addSnapshotListener { (querySnapshot, error) in
            guard error == nil else {
                print("*** ERROR: adding the snapshot listener \(error!.localizedDescription)")
                return completed()
            }
            self.diningArray = []
            for document in querySnapshot!.documents {
                let hall = DiningHall(dictionary: document.data())
                hall.documentID = document.documentID
                self.diningArray.append(hall)
            }
            completed()
        }
    }
}
