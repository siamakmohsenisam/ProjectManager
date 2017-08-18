//
//  ChartViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-18.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//
import UIKit
import Charts

class ChartViewController: UIViewController {
    
    @IBOutlet weak var pieChartView: PieChartView!
    
    
    var dataPoints = [String]()
    var values = [Double]()
    var projectLabel = ""
    
    var project : Project? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeData()
        setChart(dataPoints: dataPoints, values: values)
        
    }
    
    func makeData(){
        
        let calendar = Calendar.current
        let dateForrmater = DateFormatter()
        dateForrmater.dateFormat = "y-MM-dd h:mm:ss "
        
        var sumTaskDurationWork = Date()
        
        var taskDurationWork = DateComponents()
        var taskDuration = DateComponents()

        
        
        
        if let myProject = project {
            projectLabel = myProject.name
            
            
            for task in myProject.tasks {
                
                if task.status != "toDo" {
                    
                    taskDurationWork = calendar.dateComponents([.day], from: task.startDate , to: Date())
                    sumTaskDurationWork = calendar.date(byAdding: taskDurationWork, to: sumTaskDurationWork)!
                }
                taskDuration = calendar.dateComponents([.day], from: task.startDate , to: task.endDate)
                values.append(Double(taskDuration.day!))
                dataPoints.append(task.name)
            }
        }
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        var colors: [UIColor] = []
        
        
        
        
        for i in 0..<dataPoints.count {
            
            let dataEntry = PieChartDataEntry(value: values[i], data: dataPoints[i] as AnyObject)
            
            dataEntry.label = dataPoints[i]
            
            dataEntries.append(dataEntry)
            
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
            
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: projectLabel)
        
        pieChartDataSet.colors = colors
        
        
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
        pieChartView.data = pieChartData
        
        
        
        //        let lineChartDataSet = LineChartDataSet(values: dataEntries, label: "Units Sold")
        //        let lineChartData = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
        //        lineChartView.data = lineChartData
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}

