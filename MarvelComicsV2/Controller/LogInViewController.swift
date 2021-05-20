//
//  LogInViewController.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 18/05/2021.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true;
        
        
        // Do any additional setup after loading the view.
        SetUp()
        emailTextField.delegate = self
        passwordTextField.delegate = self

    }
    override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    func SetUp(){
        errorLabel.alpha = 0
        
        TextField.styleTextField(emailTextField)
        TextField.styleTextField(passwordTextField)
        TextField.styleFilledButton(logInButton)
        
        activityInd.hidesWhenStopped = true
        activityInd.isHidden = true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
     self.view.endEditing(true)
 }

    //MARK: - Log in Button Tapped
    
    func ValidateFields() -> String? {
        
        //Check all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please Fill in all the fields"
        }
        return nil
    }
    @IBAction func LogInButton(_ sender: Any) {
        
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        setContinueButton(enabled: false)
        activityInd.startAnimating()
        activityInd.isHidden = false
       

        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //Signing in the user
        Auth.auth().signIn(withEmail: email, password: password) {
            (result, error) in
            if error != nil{
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? ComicsHomeViewController

                self.view.window?.rootViewController = homeViewController
                self.view.window?.makeKeyAndVisible()
                //
                
               
            }
        }

    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        self.performSegue(withIdentifier: "signUp", sender: self)
       
    }
    func setContinueButton(enabled:Bool) {
          if enabled {
              logInButton.alpha = 1.0
              logInButton.isEnabled = true
          } else {
              logInButton.alpha = 0.5
              logInButton.isEnabled = false
          }
      }
    
}
