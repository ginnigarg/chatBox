//
//  ViewController.swift
//  chatBox
//
//  Created by Guneet Garg on 25/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        submitButton.layer.cornerRadius = 15
        submitButton.clipsToBounds = true
        userTextField.text = ""
        pwdTextField.text = ""
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        if let _ = Auth.auth().currentUser{
            performSegue(withIdentifier: "MainActivity", sender: self)
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    
    @IBAction func loginPressed(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        guard let userEmail = userTextField.text, !userEmail.isEmpty
            else {
                displayMyAlertMessage(userMessage: "Enter a valid Email!")
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                return
        }
        
        guard let userPassword = pwdTextField.text, !userPassword.isEmpty
            else {
                displayMyAlertMessage(userMessage: "Enter a valid Password!")
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
                return
        }
        
        if (userTextField.text != "" && pwdTextField.text != ""){
            Auth.auth().signIn(withEmail: userTextField.text!, password: pwdTextField.text!, completion: { (user, error) in
                if user != nil {
                    self.activityIndicator.isHidden = true
                    self.activityIndicator.stopAnimating()
                    self.performSegue(withIdentifier: "MainActivity", sender: sender)
                } else {
                    self.showAlertView(alertMessage: (error?.localizedDescription)!)
                }
                self.activityIndicator.isHidden = true
                self.activityIndicator.stopAnimating()
            })
        }
        
    }
    
    
    
}


