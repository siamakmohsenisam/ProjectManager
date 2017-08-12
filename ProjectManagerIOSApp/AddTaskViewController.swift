//
//  AddTaskViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-11.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit

class AddTaskViewController: UIViewController , UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var textFieldEffort: UITextField!
    @IBOutlet weak var textFieldStatus: UITextField!
    
    
    let databaseManagerRealm = DatabaseManagerRealm.sharedInstance
    var project = Project()
    var task = Task()
    let dateFormatter = DateFormatter()
    
    var myTitle : String?
    let datePicker = UIDatePicker()
    let pickerView = UIPickerView()
    let status = ["toDo", "inProgress", "done"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        dateFormatter.dateStyle = .long
        datePicker.datePickerMode = .date

        if myTitle == "Edit Task" {
            
            textFieldName.text = task.name
            textFieldStartDate.text = dateFormatter.string(from: task.startDate)
            textFieldEndDate.text = dateFormatter.string(from: task.endDate)
            textFieldEffort.text = String(task.effort)
            textFieldStatus.text = task.status
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
        navigationItem.rightBarButtonItem = addButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(showViewController))
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.title = myTitle
        
        textFieldName.addDone(done: "doneMethod", cancel: "cancelMethod", target: self)
        
        textFieldStartDate.addDatePicker(done: "doneMethod", cancel: "cancelMethod", datePicker: datePicker, target: self)
        
        textFieldEndDate.addDatePicker(done: "doneMethod", cancel: "cancelMethod", datePicker: datePicker, target: self)

        textFieldStatus.inputView = pickerView
        textFieldStatus.addDone(done: "doneMethod", cancel: "cancelMethod", target: self)
        
    }
    
    func showViewController() {
        let myNavigation = storyboard?.instantiateViewController(withIdentifier: "TaskTableViewController") as! UINavigationController
        
        let taskTableViewController = myNavigation.viewControllers[0] as? TasksTableViewController
        
        taskTableViewController?.project = project
        taskTableViewController?.tableView.reloadData()
        
        present(myNavigation , animated: true, completion: nil)
    }
    
    func saveTask(){
        
        guard let name = textFieldName.text ,
            let myStartDate = textFieldStartDate.text ,
            let myEndDate = textFieldEndDate.text ,
            let status = textFieldStatus.text ,
            let myEffort = textFieldEffort.text else {  return }
        
        guard name != "" &&
            myStartDate != "" &&
            myEndDate != "" &&
            status != "" &&
            myEffort != "" else { return  }
        
        guard let startDate = dateFormatter.date(from: myStartDate) ,
            let endDate = dateFormatter.date(from: myEndDate) ,
            let effort = Double(myEffort) else { return  }
        
        if myTitle == "Edit Task" {
            databaseManagerRealm.write(task: task, projectName: project.name, name: name, startDate: startDate, endDate: endDate, effort: effort, status: status)
        }
        else{
            task.name = name
            task.startDate = startDate
            task.endDate = endDate
            task.effort = effort
            task.status = status
           databaseManagerRealm.write(project: project, task: task)
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
        else if textFieldStatus.isEditing {
            textFieldStatus.text = status[pickerView.selectedRow(inComponent: 0)]
        }
        self.view.endEditing(true)
    }
    
    func cancelMethod() {
        self.view.endEditing(true)
    }
    
    // MARK: picker method
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return status.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return status[row]
    }

    
    
    
    
}
