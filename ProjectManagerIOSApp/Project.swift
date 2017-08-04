//
//  Project.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import Foundation
import RealmSwift

class Project: Object {
    dynamic var id = NSUUID().uuidString
    dynamic var name : String = ""
    dynamic var startDate = Date()
    dynamic var endDate = Date()
    let notes = List<MyNotes>()
    let tasks = List<Task>()
    
    // I will use this variable for delete from ios Calendar
    dynamic var identifire = ""

    
    override static func primaryKey() -> String? {
        return "id"
    }
}
