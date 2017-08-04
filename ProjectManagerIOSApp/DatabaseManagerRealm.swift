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
                if let duplicateName = realm?.objects(Project.self).filter("name = %@", project.name) {
                    if duplicateName.count > 0 {
                        project.id = duplicateName[0].id
                    }
                }
                
                realm?.add(object, update: true)
            }
        }
    }
    
    public func read <T : Object> (_ model : T.Type ,
                      complition: (Results<T>)-> () )
    {
        let result = realm?.objects(model)
        
        if let myResult = result {
            complition(myResult)
        }
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











