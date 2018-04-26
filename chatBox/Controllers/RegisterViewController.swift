//
//  RegisterViewController.swift
//  chatBox
//
//  Created by Guneet Garg on 26/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class RegisterViewController: UIViewController{
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var cnfpwdTextField: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerButton.layer.cornerRadius = 15
        registerButton.clipsToBounds = true
        subscribeToKeyboardNotification()
        nameTextField.text = ""
        emailTextField.text = ""
        pwdTextField.text = ""
        cnfpwdTextField.text = ""
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    @IBAction func registerNow(_ sender: Any) {
        if(pwdTextField.text == cnfpwdTextField.text)
        {
            Auth.auth().createUser(withEmail: emailTextField.text!, password: pwdTextField.text!) { (user, error) in
                if user != nil { //Sign Up Successful
                    print("Success")
                    DispatchQueue.main.async {
                        let userNameChangeReq = Auth.auth().currentUser?.createProfileChangeRequest()
                        userNameChangeReq?.displayName = self.nameTextField.text!
                        userNameChangeReq?.commitChanges(completion: { (error) in
                            if error != nil{
                                self.showAlertView(alertMessage: (error?.localizedDescription)!)
                            }
                        })
                    }
                    self.dismiss(animated: true, completion: nil) //Return To LoginController
                } else {
                    self.showAlertView(alertMessage: (error?.localizedDescription)!)
                }
            }
        }else{
            displayMyAlertMessage(userMessage: "Passwords Do Not Match! Try Again")
            pwdTextField.text = ""
            cnfpwdTextField.text = ""
        }
    }
}


