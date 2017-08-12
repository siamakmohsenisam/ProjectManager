//
//  TasksTableViewCell.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-11.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    @IBOutlet weak var labelEffort: UILabel!
    
    @IBOutlet weak var labelName: UILabel!
    
    @IBOutlet weak var labelStatus: UILabel!
    
    @IBOutlet weak var labelStartDate: UILabel!
    
    @IBOutlet weak var labelEndDate: UILabel!
    
    
    func updateCell(task : Task){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long

        labelName.text = task.name
        labelEffort.text = String(task.effort)
        labelStatus.text = task.status
        labelStartDate.text = dateFormatter.string(from: task.startDate)
        labelEndDate.text = dateFormatter.string(from: task.endDate)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
