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
    
    
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var switchAddReminder: UISwitch!
    @IBOutlet weak var textViewNotes: UITextView!
    
    let databaseManagerRealm = DatabaseManagerRealm.sharedInstance
    let project = Project()
    let dateFormatter = DateFormatter()
    
    var myTitle : String?
    let datePicker = UIDatePicker()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveProject))
        navigationItem.rightBarButtonItem = addButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(showViewController))
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.title = myTitle
        
        datePicker.datePickerMode = .date
        dateFormatter.dateStyle = .long
        
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
            let startDate = textFieldStartDate.text ,
            let endDate = textFieldEndDate.text else {  return }
        guard name != "" &&
            startDate != "" &&
            endDate != "" else { return  }
        
        
        project.name = name
        project.startDate = dateFormatter.date(from: startDate)!
        project.endDate = dateFormatter.date(from: endDate)!
        
        if let textNotes = textViewNotes.text {
            if textNotes != "" {
                let myNotes = MyNotes()
                myNotes.note = textNotes
                project.notes.append(myNotes)
            }
        }
        databaseManagerRealm.write(object: project)
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
    
    
    
}

extension UITextField {
    
    func addDatePicker(done: String, cancel: String, datePicker : UIDatePicker, target : UIViewController) {
        
        inputView = datePicker
        
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





