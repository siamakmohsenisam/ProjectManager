//
//  Task.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    dynamic var id = NSUUID().uuidString
    dynamic var name : String = ""
    dynamic var startDate = Date()
    dynamic var endDate = Date()
    dynamic var status = "toDo"
    dynamic var effort = Date()
    dynamic var baseEffort = Date()
    dynamic var effortStartDate = Date()
    dynamic var effortEndDate = Date()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
