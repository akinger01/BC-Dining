//
//  DiningHallViewController.swift
//  BC Dining
//
//  Created by Andrew King on 12/2/19.
//  Copyright © 2019 Andrew King. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class DiningHallViewController: UIViewController {

    //@IBOutlet weak var diningHallLabel: UILabel!
    @IBOutlet weak var menuSegmentControl: UISegmentedControl!
    @IBOutlet weak var diningHallNameLabel: UILabel!
    @IBOutlet weak var diningImage: UIImageView!
    @IBOutlet weak var diningHallMenu: UITextView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var openTimeText: UITextField!
    @IBOutlet weak var openTimeframeText: UITextField!
    @IBOutlet weak var closeTimeText: UITextField!
    @IBOutlet weak var closeTimeframText: UITextField!
    
    
    var hall: DiningHall!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if hall == nil {
            hall = DiningHall()
        }
        //updateUserInterface()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        updateUserInterface()
    }
    
    func updateUserInterface(){
        //print(hall.diningHallName)
        switch menuSegmentControl.selectedSegmentIndex {
        case 0:
            diningHallMenu.text = hall.diningHallMenuLunch
        case 1:
            diningHallMenu.text = hall.diningHallMenuDinner
        default:
            print("should never happen")
        }
        diningHallNameLabel.text = hall.diningHallName
        openTimeText.text = hall.diningHallOpenTime
        openTimeframeText.text = hall.diningHallOpenM
        closeTimeText.text = hall.diningHallCloseTime
        closeTimeframText.text = hall.diningHallCloseM
        diningImage.image = UIImage(named: hall.diningHallName)
        
        print(hall.diningHallMenuLunch)
        
        
        
        //
        if Auth.auth().currentUser?.email != "kinglx@bc.edu"{//Auth.auth().currentUser?.email{ //posted by current user
            saveButton.isEnabled = false
            openTimeText.isEnabled = false
            openTimeframeText.isEnabled = false
            closeTimeText.isEnabled = false
            closeTimeframText.isEnabled = false

            saveButton.title = ""
            cancelButton.title = "Back"
            diningHallMenu.isEditable = false
        } else {
            cancelButton.title = "Cancel"
            saveButton.title = "Save"
            saveButton.isEnabled = true
            openTimeText.isEnabled = true
            openTimeframeText.isEnabled = true
            closeTimeText.isEnabled = true
            closeTimeframText.isEnabled = true
            diningHallMenu.isEditable = true
        }
    }
    
    func updateDataFromInterface() {
        hall.diningHallOpenTime = openTimeText.text!
        hall.diningHallOpenM = openTimeframeText.text!
        hall.diningHallCloseTime = closeTimeText.text!
        hall.diningHallCloseM = closeTimeframText.text!
        switch menuSegmentControl.selectedSegmentIndex {
        case 0:
            hall.diningHallMenuLunch = diningHallMenu.text
        case 1:
            hall.diningHallMenuDinner = diningHallMenu.text
        default:
            print("should never happen")
        }
    }
    
    //from hackathon
    func leaveViewController() {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        leaveViewController()
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateDataFromInterface()
        
        hall.saveData { success in
            if success {
                self.leaveViewController()
            }else{
                print ("*** ERROR Counldn't leave this  View Controller because data wasn't saved")
            }
        }
    }
    
    @IBAction func menuSegmentPressed(_ sender: UISegmentedControl) {
        updateUserInterface()
    }
}
