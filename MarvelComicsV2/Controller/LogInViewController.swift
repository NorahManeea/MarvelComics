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
    
    //MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        SetUp()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        emailTextField.addTarget(self, action: #selector(CheckandDisplayError(text:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(CheckandDisplayError(text:)), for: .editingChanged)
        
        
    }
    
    //MARK: - Set Up Text Fields
    func SetUp(){
        errorLabel.alpha = 0
        TextField.styleTextField(emailTextField)
        TextField.styleTextField(passwordTextField)
        TextField.styleFilledButton(logInButton)
        activityInd.hidesWhenStopped = true
        activityInd.isHidden = true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else{
            view.endEditing(true)
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK: - Function to validate the fields
    func ValidateFields() -> String? {
        
        //Check all fields are filled in
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            error()
            return "Please Fill in all the fields"
        }
        return nil
    }
    //MARK: - Log in Button Tapped
    @IBAction func LogInButton(_ sender: Any) {
        
        passwordTextField.resignFirstResponder()
        setContinueButton(enabled: false)
        activityInd.startAnimating()
        activityInd.isHidden = false
        //Validate the fields
        let error = ValidateFields()
        
        if error != nil {
            ShowError(error!)
        }
        else{
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            //Signing in the user
            Auth.auth().signIn(withEmail: email, password: password) {
                (result, error) in
                guard self != nil else { return }
                if error != nil {
                    print(error)
                    
                    if error?.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." {
                        
                        Alert.showBasicAlert(on: self, with: "Something went wrong!", message: "There is no user record coressponding to this email. Please use a registered email and try again.")
                        self.error()
                    }
                    if !CheckInternet.Connection(){
                        Alert.showBasicAlert(on: self, with: "WiFi is Turned Off", message: "Please turn on cellular data or use Wi-Fi to access data.")
                        self.error()
                    }
                }
                else {
                    let homeViewController = self.storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? ComicsHomeViewController
                    
                    self.view.window?.rootViewController = homeViewController
                    self.view.window?.makeKeyAndVisible()
                    
                }
            }
            
        }
        
    }
    func ShowError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
        
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
    func error(){
        setContinueButton(enabled: true)
        self.activityInd.stopAnimating()
        self.activityInd.isHidden = true
        
    }
    
    @objc func CheckandDisplayError(text: UITextField){
        if text.isEditing == true{
            self.errorLabel.text = ""
        }
    }
    
}
