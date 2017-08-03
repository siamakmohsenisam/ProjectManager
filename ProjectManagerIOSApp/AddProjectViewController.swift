//
//  ViewController.swift
//  ProjectManagerIOSApp
//
//  Created by Siamak Mohseni Sam on 2017-08-02.
//  Copyright © 2017 Siamak Mohseni Sam. All rights reserved.
//

import UIKit
import UICircularProgressRing


class AddProjectViewController : UIViewController {

  
    
    @IBOutlet weak var ss: UICircularProgressRingView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                 ss.setProgress(value: 60, animationDuration: 20)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

