//
//  ProfileViewController.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 18/05/2021.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {

     @IBOutlet weak var nameLabel: UILabel!
     @IBOutlet weak var emailLabel: UILabel!
     @IBOutlet weak var helloLabel: UILabel!
     
     override func viewDidLoad() {
         super.viewDidLoad()
         //navigationController?.navigationBar.isHidden = true
         setName()
     }
     // MARK: - Logout Button
     @IBAction func logoutTapped(_ sender: Any) {
         
         let alert = UIAlertController(title:"Are you sure you want to log out of Marvel Comics?",message:"", preferredStyle: UIAlertController.Style.alert)
     
         alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: nil))
         self.present(alert, animated: true, completion: nil)
             
         alert.addAction(UIAlertAction(title: "Log out", style: UIAlertAction.Style.destructive, handler: { (action: UIAlertAction!) in
                      let firebaseAuth = Auth.auth()
                            UserDefaults.standard.removeObject(forKey: "uid")
                            do {
                                try firebaseAuth.signOut()
                                print("signed out")
                            } catch let signOutError as NSError {
                                print ("Error signing out: %@", signOutError)
                            }
                            
                            //Direct to sign up and login page...
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let mainVC = storyboard.instantiateViewController(identifier: "MainVC") as! MenuViewController
                            
                            self.view.window?.rootViewController = mainVC
                            self.view.window?.makeKeyAndVisible()
                       }))
         
        
         
     }
   // MARK: - Set Name Function
    
    func setName() {
        let db = Firestore.firestore()
        let userID = Auth.auth().currentUser!.uid
        db.collection("users").document(userID).getDocument { (docSnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                let name = docSnapshot?.get("name") as? String
                self.nameLabel.text = name ?? ""
                self.helloLabel.text = "Hello \( name!)"
                let email = docSnapshot?.get("email") as? String
                self.emailLabel.text = email ?? ""
                print(self.nameLabel!)
            }
        }
    }
     
 }
