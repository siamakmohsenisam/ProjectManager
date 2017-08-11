//
//  Extentions.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-03.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//
import UIKit

extension UITextField {
    
    func addDatePicker(done: String, cancel: String, datePicker : UIDatePicker, target : UIViewController) {
        
        inputView = datePicker
        addDone(done: done, cancel: cancel, target: target)
        
    }
    
    func addDone(done: String, cancel: String, target : UIViewController) {
        
        let doneSelector = Selector(done)
        let cancelSelector = Selector(cancel)
        
        let barButtonDone = UIBarButtonItem(title: "Done", style: .done, target: target, action: doneSelector)
        
        
        let barButtonSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButtonCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: cancelSelector)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([barButtonDone, barButtonSpace, barButtonCancel], animated: false)
        
        inputAccessoryView = toolbar

    }
}

extension UITextView {
    
    func addDone(done: String, cancel: String, target : UIViewController) {
        
        let doneSelector = Selector(done)
        let cancelSelector = Selector(cancel)
        
        let barButtonDone = UIBarButtonItem(title: "Done", style: .done, target: target, action: doneSelector)
        
        
        let barButtonSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let barButtonCancel = UIBarButtonItem(title: "Cancel", style: .plain, target: target, action: cancelSelector)
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        toolbar.setItems([barButtonDone, barButtonSpace, barButtonCancel], animated: false)
        
        inputAccessoryView = toolbar
        
    }
}





