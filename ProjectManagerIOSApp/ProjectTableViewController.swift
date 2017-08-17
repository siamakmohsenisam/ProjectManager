//
//  ProjectTableViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit
import RealmSwift
import UICircularProgressRing

class ProjectTableViewController: UITableViewController {

    
    let databaseManagerRealm = DatabaseManagerRealm.sharedInstance
    
    var objects = [Results<Project>]()
    var objectForEdit = Project()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
      self.addNavigationbar(title: "Table Projects", barButtonSystemItem: .add, target: self, action: "showViewController")
        
        databaseManagerRealm.read(Project.self, complition: {
            (object) in
            objects.insert(object, at: 0)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    
    func showViewController() {

        let myNavigation = storyboard?.instantiateViewController(withIdentifier: "AddProjectNavigation") as! UINavigationController
        let myViewController = myNavigation.viewControllers[0] as? AddProjectViewController
        myViewController?.myTitle = "Add New Project"
        present(myNavigation , animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return objects.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return objects[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "projectIdentifierCell", for: indexPath)

        if let myCell = cell as? ProjectTableViewCell{
            myCell.fillCell(object: objects[indexPath.section][indexPath.row])
        }
        
        // Configure the cell...

        return cell
    }
    
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
        
    }

    func deleteRow(alertAction : UIAlertAction){
        
        removeEventCalendar(eventIdentifier: objectForEdit.identifier)
        databaseManagerRealm.deleteItem(object: objectForEdit)
        tableView.reloadData()
    }
    func cancelDeleteRow(alertAction : UIAlertAction){
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        // Delete Row
        
        let delete = UITableViewRowAction(style: .normal, title: "DEL", handler: { (action , indexPath) in
            
            self.objectForEdit = self.objects[indexPath.section][indexPath.row]
            
            // Alert
            alert(message: "are you sure ?", titleButton1: "Ok", titleButton2: "Cancel", target: self, okAction:  self.deleteRow, cancelAction: self.cancelDeleteRow)
        })
        
        // Edit Row
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit", handler: { (action , indexPath) in
            
            let myNavigation = self.storyboard?.instantiateViewController(withIdentifier: "AddProjectNavigation") as! UINavigationController
            
             let addProjectViewController = myNavigation.viewControllers[0] as? AddProjectViewController
            
            addProjectViewController?.project = self.objects[indexPath.section][indexPath.row]
            addProjectViewController?.myTitle = "Edit Project"
            
            self.present(myNavigation , animated: true, completion: nil)
            
        })
        
        //   Task
        let task = UITableViewRowAction(style: .normal, title: "Task", handler: { (action , indexPath) in
            
            let myNavigation = self.storyboard?.instantiateViewController(withIdentifier: "TaskTableViewController") as! UINavigationController
            
            let tasksTableViewController = myNavigation.viewControllers[0] as? TasksTableViewController
            
            tasksTableViewController?.project = self.objects[indexPath.section][indexPath.row]
            
            self.present(myNavigation , animated: true, completion: nil)

           
        })
        //   Notes
        let notes = UITableViewRowAction(style: .normal, title: "Notes", handler: { (action , indexPath) in
            
            let myNavigation = self.storyboard?.instantiateViewController(withIdentifier: "NotesTableViewController") as! UINavigationController
            
            let notesTableViewController = myNavigation.viewControllers[0] as? NotesTableViewController
            
            notesTableViewController?.project = self.objects[indexPath.section][indexPath.row]
            
            self.present(myNavigation , animated: true, completion: nil)
            
        })

        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        task.backgroundColor = UIColor.orange
        
        return [delete, edit, task, notes]
    }
    
}
