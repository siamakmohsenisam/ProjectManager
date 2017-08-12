//
//  DatabaseManagerRealm.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//


import Foundation
import RealmSwift

class DatabaseManagerRealm : NSObject {
    
    // for Singelton
    
    public static let sharedInstance = DatabaseManagerRealm()
    private override init(){}
    
    let realm = try? Realm()
    
    // work with Realm database
    
    public func write(object : Object) {
        
        try? realm?.write {
            if let project = object as? Project {
                
                if let duplicateName = realm?.objects(Project.self).filter("name = %@", project.name).first {
                    project.id = duplicateName.id
                }
                realm?.add(object, update: true)
            }
        }
    }
    
     // update a Project
    public func write(project : Project, name : String? = nil , startDate : Date? = nil, endDate : Date? = nil, task : Task? = nil , note : MyNotes? = nil  ) {
        
        try? realm?.write
        {
            if let myName = name {
                if (realm?.objects(Project.self).filter("name = %@", myName).first) == nil {
                    project.name = myName
                }
            }
            if let myStartDate = startDate {
                project.startDate = myStartDate
            }
            if let myEndDate = endDate {
                project.endDate = myEndDate
            }
            if let myTask = task {
                if project.tasks.filter("name = %@", myTask.name).count == 0 {
                    project.tasks.append(myTask)
                }
            }
            if let myNote = note {
                project.notes.append(myNote)
            }
        }
    }
    // update a Task
    public func write(task : Task, projectName : String, name : String? = nil , startDate : Date? = nil, endDate : Date? = nil, effort : Double? = nil , status : String? = nil) {
        
        try? realm?.write
        {
            if let myName = name {
                if (realm?.objects(Project.self).filter("name = %@", projectName).first)?.tasks.filter("name = %@", myName).count == 0 {
                    task.name = myName
                }
            }
            if let myStartDate = startDate {
                task.startDate = myStartDate
            }
            if let myEndDate = endDate {
                task.endDate = myEndDate
            }
            if let myEffort = effort {
                task.effort = myEffort
            }
            if let myStatus = status {
                task.status = myStatus
            }
        }
    }
    // update a Note
    public func write(note : MyNotes, projectName : String, myNote : String) {
        
        try? realm?.write
        {
            note.note = myNote
        }
    }
    
    public func readObject <T : Object> (_ model : T.Type , name : String , complition: (Object)-> () )
    {
        guard let result = realm?.objects(Project.self).filter("name = %@", name).first else {return}
        
        complition(result)
    }
    
    public func read <T : Object> (_ model : T.Type , complition: (Results<T>)-> () )
    {
        guard let result = realm?.objects(model) else {return}
        
        complition(result)
        
    }
    
    public func deleteItem<T : Object>(object : T, project : Project? = nil, index : Int? = nil){
        try? realm?.write {
            if object is Project {
                realm?.delete(object)
            }
            if object is MyNotes {
                if let myIndex = index {
                    project?.notes.remove(objectAtIndex: myIndex)
                }
            }
            if object is Task {
                if let myIndex = index {
                    project?.tasks.remove(objectAtIndex: myIndex)
                }
            }
        }
    }
    
    public func deleteAll(){
        try? realm?.write {
            realm?.deleteAll()
        }
    }
    
}











