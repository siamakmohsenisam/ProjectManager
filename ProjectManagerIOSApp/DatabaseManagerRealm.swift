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
    
    public func write(project : Project, name : String? = nil , startDate : Date? = nil, endDate : Date? = nil, task : Task? = nil , note : MyNotes? = nil  ) {
        
        try? realm?.write
        {
            if let myName = name {
                guard (realm?.objects(Project.self).filter("name = %@", myName).first) == nil else { return }
                project.name = myName
            }
            if let myStartDate = startDate {
                project.startDate = myStartDate
            }
            if let myEndDate = endDate {
                project.endDate = myEndDate
            }
            if let myTask = task {
                project.tasks.append(myTask)
            }
            if let myNote = note {
                project.notes.append(myNote)
            }
        }
    }

    public func readObject <T : Object> (_ model : T.Type , name : String , complition: (T)-> () )
    {
        guard let result = realm?.objects(model).filter("name = %@", name).first else {return}
        
        complition(result)
        
    }
    
    public func read <T : Object> (_ model : T.Type , complition: (Results<T>)-> () )
    {
        guard let result = realm?.objects(model) else {return}
        
        complition(result)
        
    }
    
    public func deleteItem<T : Object>(object : T){
        try? realm?.write {
            realm?.delete(object)
        }
    }
    
    public func deleteAll(){
        try? realm?.write {
            realm?.deleteAll()
        }
    }
    
}











