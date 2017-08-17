//
//  TagsTableViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-11.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {
    
    let databaseManagerRealm = DatabaseManagerRealm.sharedInstance
    var project = Project()
    var index = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTask))
        addButton.tag = 1
        navigationItem.rightBarButtonItem = addButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(showViewController))
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.title = project.name
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func addTask(_ sender : Any) {
        
        
        let myNavigation = storyboard?.instantiateViewController(withIdentifier: "AddTaskNavigation") as! UINavigationController
        
        let myViewController = myNavigation.viewControllers[0] as? AddTaskTableViewController
        
        if  (sender as AnyObject).tag == 1 {
            myViewController?.myTitle = "Add New Task"
        }
        myViewController?.project = project
        present(myNavigation , animated: true, completion: nil)
    }
    
    func showViewController() {
        let myNavigation = storyboard?.instantiateViewController(withIdentifier: "TableProjectNavigation") as! UINavigationController
        
        let projectTableViewController = myNavigation.viewControllers[0] as? ProjectTableViewController
        projectTableViewController?.tableView.reloadData()
        present(myNavigation , animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return project.tasks.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TasksCellIdentifier", for: indexPath)
        
        if let myCell = cell as? TasksTableViewCell{
            myCell.updateCell(task: project.tasks[indexPath.row])
        }
        return cell
    }
    func deleteRow(alertAction : UIAlertAction){
        databaseManagerRealm.deleteItem(object: project.tasks[index], project: self.project, index: index)
        tableView.reloadData()
    }
    func cancelDeleteRow(alertAction : UIAlertAction){
        tableView.reloadData()
    }
    

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        // Delete Row
        
        let delete = UITableViewRowAction(style: .normal, title: "DEL", handler: { (action , indexPath) in
            
            self.index = indexPath.row
            alert(message: "are you sure ?", titleButton1: "Ok", titleButton2: "Cancel", target: self, okAction:  self.deleteRow, cancelAction: self.cancelDeleteRow)
        })
        // Edit Row
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action , indexPath) in
            
            let myNavigation = self.storyboard?.instantiateViewController(withIdentifier: "AddTaskNavigation") as! UINavigationController
            
            let myViewController = myNavigation.viewControllers[0] as? AddTaskTableViewController
            
            myViewController?.project = self.project
            myViewController?.task = self.project.tasks[indexPath.row]
            myViewController?.myTitle = "Edit Task"
            
            self.present(myNavigation , animated: true, completion: nil)
            
        })
        
        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
    }
    
    
    
}
