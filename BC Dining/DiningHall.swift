//
//  Dining Hall.swift
//  BC Dining
//
//  Created by Andrew King on 12/2/19.
//  Copyright © 2019 Andrew King. All rights reserved.
//

import Foundation
import Firebase

class DiningHall {
    var diningHallName: String
    var diningHallOpenTime: String
    var diningHallCloseTime: String
    var diningHallOpenM: String
    var diningHallCloseM: String
    var diningHallMenuLunch: String
    var diningHallMenuDinner: String
    var documentID: String
    var postingUserID: String
    
    var dictionary: [String: Any] {
        return ["diningHallName": diningHallName,"diningHallOpenTime": diningHallOpenTime, "diningHallCloseTime": diningHallCloseTime, "diningHallOpenM": diningHallOpenM, "diningHallCloseM": diningHallCloseM, "diningHallMenuLunch": diningHallMenuLunch, "diningHallMenuDinner": diningHallMenuDinner, "postingUserID": postingUserID]
    }

    init(diningHallName: String, diningHallOpenTime: String, diningHallCloseTime: String, diningHallOpenM: String, diningHallCloseM: String, documentID: String, postingUserID: String, diningHallMenuLunch: String, diningHallMenuDinner: String) {
        self.diningHallName = diningHallName
        self.diningHallOpenTime = diningHallOpenTime
        self.diningHallCloseTime = diningHallCloseTime
        self.diningHallOpenM = diningHallOpenM
        self.diningHallCloseM = diningHallCloseM
        self.postingUserID = postingUserID
        self.diningHallMenuLunch = diningHallMenuLunch
        self.diningHallMenuDinner = diningHallMenuDinner
        self.documentID = documentID
    }
    
    convenience init() {
        self.init(diningHallName: "", diningHallOpenTime: "", diningHallCloseTime: "", diningHallOpenM: "", diningHallCloseM: "", documentID: "", postingUserID: "", diningHallMenuLunch: "", diningHallMenuDinner: "")
    }
    
    convenience init(dictionary: [String: Any]) {
        let diningHallName = dictionary["diningHallName"] as! String? ?? ""
        let diningHallOpenTime = dictionary["diningHallOpenTime"] as! String? ?? ""
        let diningHallCloseTime = dictionary["diningHallCloseTime"] as! String? ?? ""
        let diningHallOpenM = dictionary["diningHallOpenM"] as! String? ?? ""
        let diningHallCloseM = dictionary["diningHallCloseM"] as! String? ?? ""
        let postingUserID = dictionary["postingUserID"] as! String? ?? ""
        let diningHallMenuLunch = dictionary["diningHallMenuLunch"] as! String? ?? ""
        let diningHallMenuDinner = dictionary["diningHallMenuDinner"] as! String? ?? ""
        self.init(diningHallName: diningHallName, diningHallOpenTime: diningHallOpenTime, diningHallCloseTime: diningHallCloseTime, diningHallOpenM: diningHallOpenM, diningHallCloseM: diningHallCloseM, documentID: "", postingUserID: postingUserID, diningHallMenuLunch: diningHallMenuLunch, diningHallMenuDinner: diningHallMenuDinner)
    }
    
    func saveData(completion: @escaping (Bool) -> ())  {
        let db = Firestore.firestore()
        // Grab the user ID
        guard let postingUserID = (Auth.auth().currentUser?.uid) else {
            print("*** ERROR: Could not save data because we don't have a valid postingUserID")
            return completion(false)
        }
        self.postingUserID = postingUserID
        // Create the dictionary representing data we want to save
        
        let dataToSave = self.dictionary //let dataToSave: [String: Any]
        // if we HAVE saved a record, we'll have an ID
        if self.documentID != "" {
            let ref = db.collection("dining_halls").document(self.documentID)
            ref.setData(dataToSave) { (error) in
                if let error = error {
                    print("ERROR: updating document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked!
                    completion(true)
                }
            }
        } else { // Otherwise create a new document via .addDocument
            var ref: DocumentReference? = nil // Firestore will creat a new ID for us
            ref = db.collection("dining_halls").addDocument(data: dataToSave) { (error) in
                if let error = error {
                    print("ERROR: adding document \(error.localizedDescription)")
                    completion(false)
                } else { // It worked! Save the documentID in teams's documentID property
                    self.documentID = ref!.documentID
                    completion(true)
                }
            }
        }
    }
}
