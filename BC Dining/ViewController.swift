//
//  ViewController.swift
//  BC Dining
//
//  Created by Andrew King on 12/2/19.
//  Copyright © 2019 Andrew King. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    var authUI: FUIAuth!
    var halls: DiningHalls!
    var hall: DiningHall!
    //Time
//    let date = Date()
//    let calendar = Calendar.current
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authUI = FUIAuth.defaultAuthUI()
        authUI?.delegate = self
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //self.navigationItem.title.
        
        halls = DiningHalls()
        hall = DiningHall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setToolbarHidden(false, animated: false)
        halls.loadData {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        signIn()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destination = segue.destination as! DiningHallViewController
        let selectedIndexPath = tableView.indexPathForSelectedRow!
        //destination.hallName = diningHalls[selectedIndexPath.row]
        destination.hall = halls.diningArray[selectedIndexPath.row]
    }
    
    func signIn(){
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth(),
            //FUIEmailAuth(),
        ]
        if authUI.auth?.currentUser == nil {
            self.authUI?.providers = providers
            present(authUI.authViewController(), animated: true, completion: nil)
        }else{
            tableView.isHidden = false
        }
    }
    
    //IB Actions
    @IBAction func signOutButtonPressed(_ sender: UIBarButtonItem) {
        do{
            try authUI!.signOut()
            print("^^^ Successfully signed out.")
            tableView.isHidden = true
            signIn()
        }catch{
            tableView.isHidden = true
            print("**** Couldn't sign out")
        }
    }
    
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return halls.diningArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! HallsTableViewCell
        cell.configureCell(hall: halls.diningArray[indexPath.row])
        //cell.textLabel?.text = "\(halls.diningArray[indexPath.row].diningHallName)              Status: \(hour)"
        return cell
    }
    
//    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let itemToMove = halls.diningArray[sourceIndexPath.row]
//        halls.diningArray.remove(at: sourceIndexPath.row)
//        halls.diningArray.insert(itemToMove, at: destinationIndexPath.row)
//    }
}

extension ViewController: FUIAuthDelegate{
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] ) -> Bool{
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false{
            return true
        }
        return false
    }
    func authUI(_ authUI: FUIAuth, didSignInWith user: User?, error: Error?) {
        if let user = user {
            tableView.isHidden = false
            print("**** We signed with the user \(user.email ?? "Unknown Email")")
        }
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        let loginViewController = FUIAuthPickerViewController(authUI: authUI)
        loginViewController.view.backgroundColor = UIColor.white
        
        let marginInsets: CGFloat = 16
        let imageHeight: CGFloat = 225
        let imageY = self.view.center.y - imageHeight
        let logoFrame = CGRect(x: self.view.frame.origin.x + marginInsets, y: imageY, width: self.view.frame.width - (marginInsets*2), height: imageHeight)
        let logoImageView = UIImageView(frame: logoFrame)
        logoImageView.image = UIImage(named: "logo")
        logoImageView.contentMode = .scaleAspectFit
        loginViewController.view.addSubview(logoImageView)
        return loginViewController
    }
}

