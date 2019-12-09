//
//  HallsTableViewCell.swift
//  BC Dining
//
//  Created by Andrew King on 12/9/19.
//  Copyright © 2019 Andrew King. All rights reserved.
//

import UIKit

class HallsTableViewCell: UITableViewCell {

    @IBOutlet weak var hallName: UILabel!
    @IBOutlet weak var statusCell: UILabel!
    let date = Date()
    let calendar = Calendar.current
    var status = ""
    var openTime = 0
    var closeTime = 0
    
    var hall: DiningHall!
    
    func configureCell(hall: DiningHall){
        let hour = calendar.component(.hour, from: date)
        
        hallName.text = hall.diningHallName
        openTime = Int(hall.diningHallOpenTime)!
        closeTime = Int(hall.diningHallCloseTime)!
        if hall.diningHallCloseM == "PM" || hall.diningHallCloseTime == "12" && hall.diningHallCloseM == "AM"{
            closeTime += 12
        }
        print("\(hall.diningHallName) : \(closeTime) : \(hour)")
        if hour >= openTime && hour < closeTime{
            status = "open"
        } else {
            status = "close"
            statusCell.textColor = UIColor.red
        }
        statusCell.text = "Status: \(status)"
    }
}
