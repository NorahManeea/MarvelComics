//
//  MenuViewController.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 18/05/2021.
//

import UIKit
import FirebaseAuth

class MenuViewController: UIViewController {

    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextField.styleFilledButton(signUpButton)
        TextField.styleFilledButton(logInButton)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        // To Check if user logged In
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "toHome", sender: self)
            
        }
    }
}

