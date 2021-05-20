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
    

    //MARK: - Text Field
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    //Check Fields and validate data
    func ValidateFields() -> String? {
        
        //Check all fields are filled in
        if nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please Fill in all the fields"
        }
        //Check password if it secure or not
        let pass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if TextField.isPasswordValid(pass) == false{
            //Password is not secure
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
            if  error != nil{
                self.ShowError("Error in Registration")
            }
            else {
                self.activityInd.stopAnimating()
                self.activityInd.isHidden = true
                //User was created successfully
                
                //let db = Firestore.firestore()
                /*db.collection("users").addDocument(data: ["name": name, "uid": authResult!.user.uid]) { (error) in
                    if error != nil{
                    //Show error message
                        self.ShowError("error saving user data")
                    }
        }*/
                let uid = authResult!.user.uid
                self.db.collection("users").document(uid).setData([
                    "email": self.emailTextField.text,
                    "name": self.nameTextField.text
                ])
                //transition to home screen
               // self.activityInd.startAnimating()
               // self.activityInd.isHidden = false
         
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
    //MARK: - Save User Profile Function
   /* func SaveProfile(name: String, email: String, completion: @escaping ((_ success: Bool)->())){
        guard let uid = Auth.auth().currentUser?.uid else{return}
        let databaseRef = Database.database().reference().child("users/profile/\(uid)")
        let userObject = ["name" : name, "email" : email] as [String:Any]
        databaseRef.setValue(userObject) { (error, ref) in
            completion(error == nil)
        }
}*/
}