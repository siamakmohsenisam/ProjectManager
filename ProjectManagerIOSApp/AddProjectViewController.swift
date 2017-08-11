//
//  ViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit
import UICircularProgressRing


class AddProjectViewController : UIViewController {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var switchAddReminder: UISwitch!
    
    let databaseManagerRealm = DatabaseManagerRealm.sharedInstance
    var project = Project()
    var projectName = ""
    let dateFormatter = DateFormatter()
    
    var myTitle : String?
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        datePicker.datePickerMode = .date
        dateFormatter.dateStyle = .long
        
        if projectName != "" {
            databaseManagerRealm.readObject(Project.self , name: projectName, complition: {
                (object) in
                project = object
                textFieldName.text = object.name
                textFieldStartDate.text = dateFormatter.string(from: object.startDate)
                textFieldEndDate.text = dateFormatter.string(from: object.endDate)
            })
        }
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject))
        navigationItem.rightBarButtonItem = addButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(showViewController))
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.title = myTitle
        
        textFieldName.addDone(done: "doneMethod", cancel: "cancelMethod", target: self)
        
        textFieldStartDate.addDatePicker(done: "doneMethod", cancel: "cancelMethod", datePicker: datePicker, target: self)
        
        textFieldEndDate.addDatePicker(done: "doneMethod", cancel: "cancelMethod", datePicker: datePicker, target: self)
        
    }
    
    func showViewController() {
        let myNavigation = storyboard?.instantiateViewController(withIdentifier: "TableProjectNavigation") as! UINavigationController
        
        let projectTableViewController = myNavigation.viewControllers[0] as? ProjectTableViewController
        projectTableViewController?.tableView.reloadData()
        present(myNavigation , animated: true, completion: nil)
    }
    
    func saveProject(){
        
        guard let name = textFieldName.text ,
            let myStartDate = textFieldStartDate.text ,
            let myEndDate = textFieldEndDate.text else {  return }
        guard name != "" &&
            myStartDate != "" &&
            myEndDate != "" else { return  }
        
        guard let startDate = dateFormatter.date(from: myStartDate) ,
              let endDate = dateFormatter.date(from: myEndDate) else { return  }
        
        databaseManagerRealm.write(project: project, name: name, startDate: startDate,  endDate: endDate)
        
        showViewController()
    }
    
    func doneMethod() {
        
        if textFieldStartDate.isEditing {
            textFieldStartDate.text = dateFormatter.string(from: datePicker.date)
        }
        else if textFieldEndDate.isEditing {
            textFieldEndDate.text = dateFormatter.string(from: datePicker.date)
        }
        self.view.endEditing(true)
    }
    func cancelMethod() {
        self.view.endEditing(true)
    }
    
    
    
    // keyboard method
    
    func registerForKeyboardNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden), name: .UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(_ notification: NSNotification) {
        guard let info = notification.userInfo,
            let kerboardFrameValue = info[UIKeyboardFrameBeginUserInfoKey] as? NSValue
            else { return  }
        let keyboardFrame = kerboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize.height, 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    func keyboardWillBeHidden(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
    
    
}










