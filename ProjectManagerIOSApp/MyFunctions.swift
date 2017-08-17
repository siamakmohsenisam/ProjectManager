//
//  TaskStatus.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import Foundation
import EventKit
import UIKit

public func getAuthorizationStatus(completion: (_ authorizationStatus : String)->()){
    
    var authorizationStatus = ""
    let eventStore = EKEventStore()

    switch EKEventStore.authorizationStatus(for: .event) {
        
        
    case .authorized:
        authorizationStatus = "authorized"
    case .denied:
        authorizationStatus = "denide"
    case .restricted:
        authorizationStatus = "restricted"
    case .notDetermined:
        authorizationStatus = "notDetermined"
        
        eventStore.requestAccess(to: .event , completion: { (granted , error ) in
            
            if granted {
                authorizationStatus = "denide"
            } else {
                authorizationStatus = "notDetermined"
            }
        })
    }
    completion(authorizationStatus)
}

public func addEventCalendar(myEventTitle: String, startDate: Date, endDate: Date, completion: (_ eventIdentifier: String)->()){
    
    var eventIdentifier = ""
    let eventStore = EKEventStore()
    
    switch EKEventStore.authorizationStatus(for: .event) {
        
        
    case .authorized:
        
        let event = EKEvent(eventStore: eventStore)
        event.title = myEventTitle
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        // add event into calendar
        try! eventStore.save(event, span: .thisEvent)
        // we can save this code if we want access to it . for example for delete
        eventIdentifier = event.eventIdentifier
    default: break
    }
    completion(eventIdentifier)
}



public func removeEventCalendar(eventIdentifier: String){
    
    let eventStore = EKEventStore()
    if let eventForRemove = eventStore.event(withIdentifier: eventIdentifier) {
        try? eventStore.remove(eventForRemove, span: .thisEvent)
    }
    
}

// Alert

public func alert(message : String , titleButton1 : String = "Ok" , titleButton2 : String = "" ,target : UIViewController, okAction : ((UIAlertAction) -> ())? = nil, cancelAction : ((UIAlertAction) -> ())? = nil ){
    
    
    let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: titleButton1, style: .default, handler: okAction)
    alert.addAction(okAction)
    
    if titleButton2 != "" {
        let cancelAction = UIAlertAction(title: titleButton2, style: .default, handler: cancelAction)
        alert.addAction(cancelAction)
    }
        target.present(alert, animated: true, completion: nil)
    
    
}











