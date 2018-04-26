//
//  MainViewController.swift
//  chatBox
//
//  Created by Guneet Garg on 26/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class MainViewController: UIViewController {
    
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var usernameTextLabel: UILabel!
    
    var dbReference : DatabaseReference!
    var dbHandler : DatabaseHandle!
    var storageReference : StorageReference!
    var messages : [DataSnapshot]! = []
    var currentUser = "Guneet Garg"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        databaseSetup()
        delegateSetup()
        storageSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotification()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func delegateSetup() {
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextField.delegate = self as? UITextFieldDelegate
    }
    
    func databaseSetup(){
        dbReference = Database.database().reference()
        dbHandler = dbReference.child("messages").observe(.childAdded){(snapshot : DataSnapshot) in
            self.messages.append(snapshot)
            self.messageTableView.insertRows(at: [IndexPath(row: self.messages.count-1,section: 0)], with: .automatic)
            self.messageTableView.reloadData()
        }
        currentUser = (Auth.auth().currentUser?.displayName)!
        usernameTextLabel.text = "\(currentUser) Logged In"
    }
    
    func storageSetup(){
        storageReference = Storage.storage().reference()
    }

    @IBAction func CameraAction(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    func sendMessage(imageurl:String = "") {
        if imageurl == ""{
            if messageTextField.text != ""{
                let data = [Constants.messageFields.username : "\(currentUser)",Constants.messageFields.text : messageTextField.text!]
                messageTextField.text = ""
                messageTextField.resignFirstResponder()
                dbReference.child("messages").childByAutoId().setValue(data)
            }
        } else {
            let data = [Constants.messageFields.username : "\(currentUser)",Constants.messageFields.imageURL : imageurl]
            dbReference.child("messages").childByAutoId().setValue(data)
            
        }
    }
    
    @IBAction func SendMsgAction(_ sender: Any) {
        sendMessage()
    }
    @IBAction func logOutAction(_ sender: UIButton) {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
}
