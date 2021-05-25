//
//  SignUpViewController.swift
//  MarvelComicsV2
//
//  Created by Norah Almaneea on 18/05/2021.
//

import UIKit
import FirebaseAuth
import Firebase

class SignUpViewController: UIViewController, UITextFieldDelegate{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    var db: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.navigationController?.navigationBar.isHidden = true;
        db = Firestore.firestore()
        
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self
        SetUp()
        nameTextField.addTarget(self, action: #selector(CheckandDisplayError(text:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(CheckandDisplayError(text:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(CheckandDisplayError(text:)), for: .editingChanged)
    }

    func SetUp(){
        //Hide Error Label and activityInd
        errorLabel.alpha = 0
        activityInd.stopAnimating()
        activityInd.isHidden = true
        //Style Elements
        TextField.styleTextField(nameTextField)
        TextField.styleTextField(emailTextField)
        TextField.styleTextField(passwordTextField)
        TextField.styleFilledButton(signUpButton)
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField{
            emailTextField.becomeFirstResponder()
        }
        else if textField == emailTextField{
            passwordTextField.becomeFirstResponder()
        }
        else{
            view.endEditing(true)
        }
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //Check Fields and validate data
    func ValidateFields() -> String? {
        
        //Check all fields are filled in
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            error()
            return "Please Fill in all the fields"
        }
        //Check password if it secure or not
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if TextField.isPasswordValid(pass) == false{
            //Password is not secure
            error()
            return "Password must be at least 8 character.\n*Contain a special character and number"
        }
        return nil
    }
    //MARK: - Sign Up Button Tapped
    @IBAction func SignUpButton(_ sender: Any) {
        setContinueButton(enabled: false)
        activityInd.startAnimating()
        activityInd.isHidden = false
        //Validate the fields
        let error = ValidateFields()
        
        if error != nil {
            ShowError(error!)
        }
        else{
            
            let name = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

            //Create user
            Auth.auth().createUser(withEmail: email , password: password) { authResult, error in
                //Check for error
                if error != nil {
                    if error?.localizedDescription == "The email address is already in use by another account." {
                        
                        //  display alert
                        //  Handling already existing email
                        let alert = UIAlertController(title: "Something went wrong!", message: "The email address is already in use by another account, please try again." , preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                    }
                    
                    if !CheckInternet.Connection(){
                        Alert.showBasicAlert(on: self, with: "WiFi is Turned Off", message: "Please turn on cellular data or use Wi-Fi to access data.")
                    }
                    print(error)
                }
                else {
                    self.activityInd.stopAnimating()
                    self.activityInd.isHidden = true
                    let uid = authResult!.user.uid
                    self.db.collection("users").document(uid).setData([
                        "email": self.emailTextField.text,
                        "name": self.nameTextField.text
                    ])
                    //transition to home screen
                    self.TransitionToHome()
                }
            }
        }
    }
    
    func ShowError(_ message:String){
        errorLabel.text = message
        errorLabel.alpha = 1
        
    }
    func TransitionToHome(){
        let homeViewController = storyboard?.instantiateViewController(identifier: Constants.Storyboard.homeViewController) as? ComicsHomeViewController
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }
    
    //MARK:- Enables or Disables the SignUp Button.
    func setContinueButton(enabled:Bool) {
        if enabled {
            signUpButton.alpha = 1.0
            signUpButton.isEnabled = true
        } else {
            signUpButton.alpha = 0.5
            signUpButton.isEnabled = false
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
