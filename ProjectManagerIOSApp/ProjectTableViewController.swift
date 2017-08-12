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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showViewController))
        addButton.tag = 1
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Table Projects"
        
        databaseManagerRealm.read(Project.self, complition: {
            (object) in
            objects.insert(object, at: 0)
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    func showViewController(_ sender : Any) {
        
        let myNavigation = storyboard?.instantiateViewController(withIdentifier: "AddProjectNavigation") as! UINavigationController
        
        let myViewController = myNavigation.viewControllers[0] as? AddProjectViewController
        

        if  (sender as AnyObject).tag == 1 {
            myViewController?.myTitle = "Add New Project"
        }
        
        present(myNavigation , animated: true, completion: nil)
    
    }
    
    
    
    
    func calculatePercent() -> Int {
        
   //     duration = Calendar.current.dateComponents([.day], from: startDate, to: endDate).day!
        
        return 0
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
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        // Delete Row
        
        let delete = UITableViewRowAction(style: .normal, title: "DEL", handler: { (action , indexPath) in
            
            let objectForDelete = self.objects[indexPath.section][indexPath.row]
            
            // Alert
            
            let alert = UIAlertController(title: "Warning", message: "are you sure ?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                (myAction) in
                self.databaseManagerRealm.deleteItem(object: objectForDelete)
                self.tableView.reloadData()
            })
            alert.addAction(okAction)
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (myAction) in
                self.tableView.reloadData()
            })
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
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

    
    
    
    
    
    
    
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
