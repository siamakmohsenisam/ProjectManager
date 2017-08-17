//
//  ProjectTableViewCell.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit
import UICircularProgressRing

class ProjectTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var viewPercent: UICircularProgressRingView!
    
    @IBOutlet weak var numberTasks: UILabel!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelEndDate: UILabel!
    
    func fillCell(object : Project){        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
               
        labelName.text = object.name
        labelStartDate.text = dateFormatter.string(from: object.startDate)
        labelEndDate.text = dateFormatter.string(from: object.endDate)
        numberTasks.text = String(object.tasks.count) + " tasks"
        viewPercent.setProgress(value: CGFloat(calculatePercent(project: object)), animationDuration: 0)
    }
    
    func calculatePercent(project : Project) -> Int {
        
        var percent = 0
        let calendar = Calendar.current
        let dateForrmater = DateFormatter()
        dateForrmater.dateFormat = "y-MM-dd h:mm:ss "
        
        var sumTaskDurationWork = Date()
        var sumTaskDuration = Date()
        
        var taskDurationWork = DateComponents()
        var taskDuration = DateComponents()
        
        
        for task in project.tasks {
            
            if task.status != "toDo" {
                
                taskDurationWork = calendar.dateComponents([.day], from: task.startDate , to: Date())
                sumTaskDurationWork = calendar.date(byAdding: taskDurationWork, to: sumTaskDurationWork)!
            }
            taskDuration = calendar.dateComponents([.day], from: task.startDate , to: task.endDate)
            sumTaskDuration = calendar.date(byAdding: taskDuration, to: sumTaskDuration)!
        }
        
        let x1 = calendar.dateComponents([.day], from: sumTaskDurationWork , to: Date()).day
        let y1 = calendar.dateComponents([.day], from: sumTaskDuration , to: Date()).day
        
        if let y = y1 ,
            let x = x1
        {
            guard y != 0 else {  return 0 }
            percent = (x * 100) / y
        }
        return percent
    }
    
    
    
    
}
