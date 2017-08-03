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
   
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelStartDate: UILabel!
    @IBOutlet weak var labelEndDate: UILabel!
    
    func fillCell(object : AnyObject){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .medium
        
        if object is Project{
           
            labelName.text = object.name
            labelStartDate.text = dateFormatter.string(from: object.startDate)
            labelEndDate.text = dateFormatter.string(from: object.endDate)
       //     viewPercent.setProgress(value: <#T##CGFloat#>, animationDuration: 0)
            
        }
    }
    


}
