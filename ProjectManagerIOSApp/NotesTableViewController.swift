//
//  NotesTableViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-11.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit
import RealmSwift

class NotesTableViewController: UITableViewController {
    
    let databaseManagerRealm = DatabaseManagerRealm.sharedInstance
    var project = Project()
    var index = -1
    var textView = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        navigationItem.rightBarButtonItem = addButton
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(showViewController))
        navigationItem.leftBarButtonItem = cancelButton
        
        navigationItem.title = project.name
        
    }
    
    func addNote() {
        textView.frame = tableView.frame
        textView.addDone(done: "doneTextView", cancel: "cancleEditText", target: self)
        textView.becomeFirstResponder()
        view.addSubview(textView)
    }
    
    func doneTextView(){
        guard textView.text != "" else {
            alert(mesage: "You must fill textfield")
            return
        }
        if index == -1{
            let note = MyNotes()
            if let myText = textView.text {
                note.note = myText
            }
            databaseManagerRealm.write(project: project, note: note)
            textView.text = ""
        }
        else {
            if let myText = textView.text {
                databaseManagerRealm.write(note: project.notes[index], projectName: project.name, myNote: myText)
                index = -1
                textView.text = ""
            }
        }
        tableView.reloadData()
        textView.removeFromSuperview()
    }
    
    func cancleEditText(){
        tableView.reloadData()
        textView.removeFromSuperview()
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
        return project.notes.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCellIdentifier", for: indexPath)
        
        if let myCell = cell as? NotesTableViewCell{
            myCell.textViewNote.text = project.notes[indexPath.row].note
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        // Delete Row
        
        let delete = UITableViewRowAction(style: .normal, title: "DEL", handler: { (action , indexPath) in
            
            let objectForDelete = self.project.notes[indexPath.row]
            
            // Alert
            
            let alert = UIAlertController(title: "Warning", message: "are you sure ?", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: {
                (myAction) in
                self.databaseManagerRealm.deleteItem(object: objectForDelete, project: self.project, index: indexPath.row)
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
            self.index = indexPath.row
            self.addNote()
            self.textView.text = self.project.notes[indexPath.row].note
        })
        
        
        delete.backgroundColor = UIColor.red
        edit.backgroundColor = UIColor.blue
        
        return [delete, edit]
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
