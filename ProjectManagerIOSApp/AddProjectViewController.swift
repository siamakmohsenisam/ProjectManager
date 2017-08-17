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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.datePickerMode = .date
        dateFormatter.dateStyle = .long
                
        if myTitle == "Edit Project" {
            textFieldName.text = project.name
            textFieldStartDate.text = dateFormatter.string(from: project.startDate)
            textFieldEndDate.text = dateFormatter.string(from: project.endDate)
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
            myEndDate != "" else {
                alert(mesage: "You must fill all textfields")
                return  }
        
        guard let startDate = dateFormatter.date(from: myStartDate) ,
            let endDate = dateFormatter.date(from: myEndDate) else { return  }
        
        guard startDate <= endDate else {
            alert(mesage: "start date project must be less than end date ")
            return
        }
        
        if project.tasks.count != 0 {
            
            
            if project.tasks.filter("startDate < %@" , startDate).count != 0 {
                alert(mesage: "there are some tasks then they have start date less than start project ")
                return
            }
            
            if project.tasks.filter("endDate > %@" , endDate).count != 0 {
                alert(mesage: "there are some tasks then they have end date bigger than end project ")
                return
            }
        }
        
        if myTitle == "Edit Project" {
            databaseManagerRealm.write(project: project, name: name, startDate: startDate,  endDate: endDate)
        }
        else{
            project.name = name
            project.startDate = startDate
            project.endDate = endDate
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
        self.view.endEditing(true)
    }
    
    
    // Alert
    func alert(mesage : String , titleButton1 : String = "Ok" , titleButton2 : String = "" , okAction : ((UIAlertAction) -> ())? = nil, cancelAction : ((UIAlertAction) -> ())? = nil ){
        
        let alert = UIAlertController(title: "Warning", message: mesage, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: titleButton1, style: .default, handler: okAction)
        alert.addAction(okAction)
        
        if titleButton2 != "" {
            let cancelAction = UIAlertAction(title: titleButton2, style: .default, handler: cancelAction)
            alert.addAction(cancelAction)
        }
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    
}










