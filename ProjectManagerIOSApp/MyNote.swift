//
//  Note.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-03.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import Foundation
import RealmSwift

class MyNote: Object {
    dynamic var id = NSUUID().uuidString
    dynamic var note : String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
