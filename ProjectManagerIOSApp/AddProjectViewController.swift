//
//  ViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit
import UICircularProgressRing

class AddProjectViewController : UITableViewController {
    
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var switchAddReminder: UISwitch!
    
    let databaseManagerRealm = DatabaseManagerRealm.sharedInstance
    var project = Project()
   
    
    var myTitle : String?
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()

    var authorizationStatus = ""
    var identifier = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        getAuthorizationStatus(completion: {
        (authorizationStatus) in
            self.authorizationStatus = authorizationStatus
        })
        
        datePicker.datePickerMode = .date
        dateFormatter.dateStyle = .long
                
        if myTitle == "Edit Project" {
            textFieldName.text = project.name
            textFieldStartDate.text = dateFormatter.string(from: project.startDate)
            textFieldEndDate.text = dateFormatter.string(from: project.endDate)
            if project.identifier != "" {
                switchAddReminder.setOn(true, animated: true)
            }
            else{
                switchAddReminder.setOn(false, animated: true)
            }
            identifier = project.identifier
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
    func saveProject()  {
        self.activityIndicatorView.startAnimating()
        DispatchQueue.main.async {
            self.saveProjectAfter()
        }
    }
    
    func saveProjectAfter(){
     
        
        guard let name = textFieldName.text ,
            let myStartDate = textFieldStartDate.text ,
            let myEndDate = textFieldEndDate.text else {  return }
        
        guard name != "" &&
            myStartDate != "" &&
            myEndDate != "" else {
                alert(message: "You must fill all textfields", target: self)
                return  }
        
        guard let startDate = dateFormatter.date(from: myStartDate) ,
            let endDate = dateFormatter.date(from: myEndDate) else { return  }
        
        guard startDate <= endDate else {
            alert(message: "start date project must be less than end date ", target: self)
            return
        }
        
        if project.tasks.count != 0 {
            
            
            if project.tasks.filter("startDate < %@" , startDate).count != 0 {
                alert(message: "there are some tasks then they have start date less than start project ", target: self)
                return
            }
            
            if project.tasks.filter("endDate > %@" , endDate).count != 0 {
                alert(message: "there are some tasks then they have end date bigger than end project ", target: self)
                return
            }
        }
        
        if switchAddReminder.isOn {
            
            if identifier != "" {
                removeEventCalendar(eventIdentifier: identifier)
                identifier = ""
            }
           
            addEventCalendar(myEventTitle: name, startDate: startDate, endDate: endDate, completion: {
                (eventIdentifier) in
                
                if eventIdentifier != "" {
                    self.identifier = eventIdentifier
                }
                else {
                    alert(message: "app can not access to ios event calendar. your authorization is \(self.authorizationStatus) ", target: self)
                }
                self.activityIndicatorView.stopAnimating()
            })
  
            
        }
        else {
            if identifier != "" {
                removeEventCalendar(eventIdentifier: identifier)
                identifier = ""
            }
        }
        
        if myTitle == "Edit Project" {
            
            databaseManagerRealm.write(project: project, name: name, startDate: startDate,  endDate: endDate , identifier: identifier)
        }
        else{
            project.name = name
            project.startDate = startDate
            project.endDate = endDate
            project.identifier = identifier
            databaseManagerRealm.write(object: project)
        }
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
        if textFieldStartDate.isEditing {
            textFieldStartDate.text = ""
        }
        else if textFieldEndDate.isEditing {
            textFieldEndDate.text = ""
        }
        if textFieldName.isEditing {
            textFieldName.text = ""
        }
        self.view.endEditing(true)
        
    }
    
    
    
}










