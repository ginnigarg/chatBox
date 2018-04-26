//
//  ViewController.swift
//  chatBox
//
//  Created by Guneet Garg on 25/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import UIKit
import FirebaseAuth
import MapKit
import CoreLocation

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var userTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let locationManager = CLLocationManager()
    var userLocations = CLLocationCoordinate2D()
    var locationValue = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submitButton.layer.cornerRadius = 15
        submitButton.clipsToBounds = true
        userTextField.text = ""
        pwdTextField.text = ""
        locationManagerSetup()
        NotificationCenter.default.addObserver(self, selector: #selector(updateWeatherLabel) , name: Notification.Name.ValueChanged, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
        if let _ = Auth.auth().currentUser{
            performSegue(withIdentifier: "MainActivity", sender: self)
        }
    }
    
    @objc func updateWeatherLabel(){
        let networkingInstance = Networking()
        locationValue = networkingInstance.getValues()
        DispatchQueue.main.async {
            self.weatherLabel.text = "Today It's \(self.locationValue[0]) over \(self.locationValue[1])"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    fileprivate func locationManagerSetup() {
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled(){
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        activityIndicator.startAnimating()
        guard let userEmail = userTextField.text, !userEmail.isEmpty
            else {
                displayMyAlertMessage(userMessage: "Enter a valid Email!")
                self.activityIndicator.stopAnimating()
                return
        }
        
        guard let userPassword = pwdTextField.text, !userPassword.isEmpty
            else {
                displayMyAlertMessage(userMessage: "Enter a valid Password!")
                self.activityIndicator.stopAnimating()
                return
        }
        
        if (userTextField.text != "" && pwdTextField.text != ""){
            Auth.auth().signIn(withEmail: userTextField.text!, password: pwdTextField.text!, completion: { (user, error) in
                if user != nil { //User Signed In Successfully
                    self.performSegue(withIdentifier: "MainActivity", sender: sender)
                } else { //Failed Authentication
                    self.showAlertView(alertMessage: (error?.localizedDescription)!)
                }
                self.activityIndicator.startAnimating()
            })
        }
        
    }
    
    
    
}


