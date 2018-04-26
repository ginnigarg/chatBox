//
//  RegisterViewControllerExtension.swift
//  chatBox
//
//  Created by Guneet Garg on 26/04/18.
//  Copyright © 2018 Guneet Garg. All rights reserved.
//

import Foundation
import UIKit

extension RegisterViewController{
    
    func subscribeToKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(returnKeyboardBack), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
            if (nameTextField.isFirstResponder || emailTextField.isFirstResponder || pwdTextField.isFirstResponder || cnfpwdTextField.isFirstResponder) {
                view.frame.origin.y = (-getKeyboardHeight(notification)+65)
            }
        } else {
            if (pwdTextField.isFirstResponder) {
                view.frame.origin.y = (-getKeyboardHeight(notification)+100)
            }
        }
    }
    
    @objc func returnKeyboardBack(){
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation){
            if (nameTextField.isFirstResponder || emailTextField.isFirstResponder || pwdTextField.isFirstResponder || cnfpwdTextField.isFirstResponder) {
                view.frame.origin.y=0
            }
        } else {
            if (pwdTextField.isFirstResponder) {
                view.frame.origin.y=0
            }
        }
    }
}
