//
//  MainViewControllerExtension.swift
//  chatBox
//
//  Created by Guneet Garg on 26/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension MainViewController{
    
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(returnKeyboardBack), name: .UIKeyboardWillHide, object: nil)
    }

    @objc func keyboardWillShow(_ notification:Notification) {
        if (messageTextField.isFirstResponder) {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    @objc func returnKeyboardBack(){
        if (messageTextField.isFirstResponder) {
            view.frame.origin.y=0
        }
    }
}


extension MainViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let prototypeCell = messageTableView.dequeueReusableCell(withIdentifier: "messageBox", for: indexPath)
        let messageSnapshot : DataSnapshot = messages[indexPath.row]
        let message = messageSnapshot.value as! [String:String]
        if message[Constants.messageFields.text] == nil{
            let imageURL = message[Constants.messageFields.imageURL]
            Storage.storage().reference(forURL: imageURL!).getData(maxSize: INT64_MAX, completion: { (data, error) in
                if error == nil {
                    let messageImage = UIImage.init(data: data!, scale: 50)
                    if prototypeCell == tableView.cellForRow(at: indexPath){
                        prototypeCell.imageView?.image = messageImage
                        prototypeCell.setNeedsLayout()
                    }
                } else {
                    self.showAlertView(alertMessage: (error?.localizedDescription)!)
                }
            })
            prototypeCell.textLabel?.text = "By \(message[Constants.messageFields.username] ?? "")"
        } else {
            prototypeCell.textLabel?.text = message[Constants.messageFields.username]! + ": " + message[Constants.messageFields.text]!
        }
        return prototypeCell
    }
}

extension MainViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageToSave = info[UIImagePickerControllerOriginalImage] as? UIImage , let imageData = UIImageJPEGRepresentation(imageToSave, 0.8){
            sendPhotoMsg(imageData: imageData)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func sendPhotoMsg(imageData : Data){
        let imagePath = "chat-photos/"+(Auth.auth().currentUser?.uid)!+"\(Double(Date.timeIntervalSinceReferenceDate*1000)).jpeg"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        storageReference.child(imagePath).putData(imageData, metadata: metaData) { (metadata, error) in
            if error == nil{
                print("Image Saved Successfully")
                self.sendMessage(imageurl: self.storageReference.child(metaData.path!).description)
            } else{
                self.showAlertView(alertMessage: (error?.localizedDescription)!)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}


