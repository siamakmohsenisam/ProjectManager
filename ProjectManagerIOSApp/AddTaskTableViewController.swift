//
//  AddTaskTableViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-14.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit

class AddTaskTableViewController: UITableViewController  , UIPickerViewDelegate, UIPickerViewDataSource{
    
    
    @IBOutlet weak var textFieldName: UITextField!
    @IBOutlet weak var textFieldStartDate: UITextField!
    @IBOutlet weak var textFieldEndDate: UITextField!
    @IBOutlet weak var labelEffort: UILabel!
    @IBOutlet weak var textFieldStatus: UITextField!
    @IBOutlet weak var textFieldStartEffort: UITextField!
    @IBOutlet weak var textFieldPauseEffort: UITextField!
    @IBOutlet weak var durationEffort: UILabel!
    @IBAction func buttonStartTimer(_ sender: UIButton) {
        
        guard textFieldStatus.text == "inProgress" else {
            alert(message: "you can't set timer start effort when your status task is toDo or Done", target: self)
            return
        }
        textFieldStartEffort.text = timeFormatter.string(from: Date())

    }
    @IBAction func buttonPauseTimer(_ sender: UIButton) {
      
            
            guard textFieldStartEffort.text != "" else {
                alert(message: "first you must fill start effort time", target: self)
                return }
            
            textFieldPauseEffort.text = timeFormatter.string(from: Date())
            let date1 = timeFormatter.date(from: textFieldStartEffort.text!)
            let date2 = timeFormatter.date(from: textFieldPauseEffort.text!)
            
            let duration = calendar.dateComponents([.hour, .minute], from: date1!, to: date2!)
            
            guard let myHour = duration.hour,
                let myMinute = duration.minute
                else { return }
            durationHour = myHour
            durationMinute = myMinute
            durationEffort.text = "you work : " + String(myHour) + " Hour and " + String(myMinute) + " Minute"
        }
    
    
    
    
    let databaseManagerRealm = DatabaseManagerRealm.sharedInstance
    var project = Project()
    var task = Task()
    
    var myTitle : String?
    let datePicker = UIDatePicker()
    let timePicker = UIDatePicker()
    let dateFormatter = DateFormatter()
    let timeFormatter = DateFormatter()
    
    var durationHour = 0
    var durationMinute = 0
    var effortStartDate = Date()
    var effortEndDate = Date()
    var baseEffort = Date()
    var effort = Date()
    
    
    
    let calendar = Calendar.current
    let pickerView = UIPickerView()
    
    let status = ["toDo", "inProgress", "done"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
        
        dateFormatter.dateStyle = .long
        timeFormatter.dateStyle = .long
        timeFormatter.timeStyle = .medium
        datePicker.datePickerMode = .date
        timePicker.datePickerMode = .dateAndTime
        
        labelEffort.text = "00:00"
        
        if myTitle == "Edit Task" {
            
            textFieldName.text = task.name
            textFieldStartDate.text = dateFormatter.string(from: task.startDate)
            textFieldEndDate.text = dateFormatter.string(from: task.endDate)
            let component = calendar.dateComponents([.hour, .minute], from: task.baseEffort, to: task.effort)
            guard let h = component.hour,
                let m = component.minute else { return  }
            labelEffort.text = "\(h):\(m)"
            textFieldStatus.text = task.status
            baseEffort = task.baseEffort
            effort = task.effort
            effortStartDate = task.effortStartDate
            effortEndDate = task.effortEndDate
            
            if  task.effortEndDate != task.effortStartDate {
                textFieldStartEffort.text = timeFormatter.string(from: task.effortStartDate)
            }
            
        }
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveTask))
        navigationItem.rightBarButtonItem = addButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(showViewController))
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.title = myTitle
        
        textFieldName.addDone(done: "doneMethod", cancel: "cancelMethod", target: self)
        
        textFieldStartDate.addDatePicker(done: "doneMethod", cancel: "cancelMethod", datePicker: datePicker, target: self)
        
        textFieldEndDate.addDatePicker(done: "doneMethod", cancel: "cancelMethod", datePicker: datePicker, target: self)
        
        textFieldStartEffort.addDatePicker(done: "doneMethod", cancel: "cancelMethod", datePicker: timePicker, target: self)
        
        textFieldPauseEffort.addDatePicker(done: "doneMethod", cancel: "cancelMethod", datePicker: timePicker, target: self)
        
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
            let myEffort = labelEffort.text else {  return }
        
        guard name != "" &&
            myStartDate != "" &&
            myEndDate != "" &&
            status != "" &&
            myEffort != "" else {
                alert(message: "You must fill all textfields", target: self)
                return  }
        
        guard let startDate = dateFormatter.date(from: myStartDate) ,
            let endDate = dateFormatter.date(from: myEndDate) else {
                alert(message: "Your effort is not correct", target: self)
                return  }
        guard startDate >= project.startDate else {
            alert(message: "you can't set start date task befor start project", target: self)
            return }
        guard endDate <= project.endDate else {
            alert(message: "you can't set end date task after end project", target: self)
            return }
        
        if status == "toDo" && baseEffort < effort  {
            
            alert(message: "when status is toDo then effort must be. zero Do you want change that ?", titleButton1: "Ok", titleButton2: "Cancel", target: self, okAction: changeBaseEffort, cancelAction: doNotChangeEffort)
            
            return }
        
         if status == "toDo"  {
            changeBaseEffort(UIAlertAction())
        }
        
        var startTaskDate = startDate
        var endTaskDate = endDate
        
        // if we want update task
        
        if myTitle == "Edit Task" {
            
            if task.status == "toDo" && status == "inProgress"{
                if project.startDate <= Date() {
                    startTaskDate = Date()
                }
                else {
                    alert(message: "start of task must be bigger than start of project ", target: self)
                    return }
            }
            
            if task.status == "inProgress" && status == "done"{
                if project.endDate >= Date() {
                    endTaskDate = Date()
                }
                else {
                    alert(message: "end of task must be less than end of project ", target: self)
                    return }
            }
            
            if task.status == "toDo" && status == "done"{
                alert(message: "first have to have in progress status ", target: self)
                return
            }
            
            
            if task.status == "done" && status == "toDo"{
                alert(message: "first have to have in progress status", target: self)
                return
                
            }

            
            guard startTaskDate <= endTaskDate else {
                alert(message: "start date task must be less than end date ", target: self)
                return  }
            
            if durationHour != 0 || durationMinute != 0 {
                effort = calendar.date(byAdding: .hour, value: durationHour, to: effort)!
                effort = calendar.date(byAdding: .minute, value: durationMinute, to: effort)!
                durationMinute = 0
                durationHour = 0
                effortStartDate = effortEndDate
                textFieldStartEffort.text = ""
            }

            if let myStartEffort = textFieldStartEffort.text {
                if myStartEffort != "" {
                    effortStartDate = timeFormatter.date(from: myStartEffort)!
                }
            }
            
            
            databaseManagerRealm.write(task: task, projectName: project.name, name: name, startDate: startTaskDate, endDate: endTaskDate, effort: effort, status: status, baseEffort: baseEffort, effortStartDate: effortStartDate, effortEndDate : effortEndDate)
        }
            
            //  if we want add new task
            
        else{
            
            if status == "inProgress" {
                if project.startDate <= Date() {
                    startTaskDate = Date()
                }
                else {
                    alert(message: "start of task must be bigger than start of project ", target: self)
                    return }
            }
            
            if status == "done" {
                if project.endDate >= Date() {
                    endTaskDate = Date()
                }
                else {
                    alert(message: "end of task must be less than end of project ", target: self)
                    return }
            }
            
            guard startTaskDate <= endTaskDate else {
                alert(message: "start date task must be less than end date ", target: self)
                return  }
            task.name = name
            task.startDate = startTaskDate
            task.endDate = endTaskDate
            task.status = status
            task.effort = Date()
            task.baseEffort = task.effort
            task.effortStartDate = task.effortEndDate
            
            if durationHour != 0 || durationMinute != 0 {
                task.effort = calendar.date(byAdding: .hour, value: durationHour, to: task.effort)!
                task.effort = calendar.date(byAdding: .minute, value: durationMinute, to: task.effort)!
                durationMinute = 0
                durationHour = 0
                task.effortEndDate = task.effortStartDate
                textFieldStartEffort.text = ""
            }
            
            if let startEffort = textFieldStartEffort.text {
                if startEffort != "" {
                    task.effortStartDate = timeFormatter.date(from: startEffort)!
                }
            }
            
            
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
            
        else if textFieldStartEffort.isEditing {
            guard textFieldStatus.text == "inProgress" else {
                alert(message: "you can't set timer start effort when your status task is toDo or Done", target: self)
                return
            }
            textFieldStartEffort.text = timeFormatter.string(from: timePicker.date)
        }
        else if textFieldPauseEffort.isEditing {
            
            guard textFieldStartEffort.text != "" else {
                alert(message: "first you must fill start effort time", target: self)
                return }
            
            textFieldPauseEffort.text = timeFormatter.string(from: timePicker.date)
            let date1 = timeFormatter.date(from: textFieldStartEffort.text!)
            let date2 = timeFormatter.date(from: textFieldPauseEffort.text!)
            
            let duration = calendar.dateComponents([.hour, .minute], from: date1!, to: date2!)
            
            guard let myHour = duration.hour,
                let myMinute = duration.minute
                else { return }
            durationHour = myHour
            durationMinute = myMinute
            durationEffort.text = "you work : " + String(myHour) + " Hour and " + String(myMinute) + " Minute"
            //       labelEffort.text
        }
        else if textFieldStatus.isEditing {
            textFieldStatus.text = status[pickerView.selectedRow(inComponent: 0)]
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
        else if textFieldStartEffort.isEditing {
            textFieldStartEffort.text = ""
        }
        else if textFieldPauseEffort.isEditing {
           textFieldPauseEffort.text = ""
        }
        else if textFieldStatus.isEditing {
            textFieldStatus.text = ""
        }
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
    
    
     
    func changeBaseEffort(_ sender : UIAlertAction){
        effortStartDate = effortEndDate
        effort = baseEffort
        durationEffort.text = "you can start and end manualy or automatic with button"
        labelEffort.text = "0:0"
        durationHour = 0
        durationMinute = 0
        textFieldStartEffort.text = ""
        textFieldPauseEffort.text = ""
        return
    }
    func doNotChangeEffort(_ sender : UIAlertAction){
        return
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

    
}
