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
        self.navigationController?.navigationBar.isHidden = true;

        TextField.styleFilledButton(signUpButton)
        TextField.styleFilledButton(logInButton)
    }
   
    override func viewDidAppear(_ animated: Bool) {
        if let user = Auth.auth().currentUser {
            self.performSegue(withIdentifier: "toHome", sender: self)
            
        }
    }
}

