//
//  StudentReviewPage.swift
//  448Piano
//
//  Created by William Bertrand on 5/2/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import SwiftChart

class StudentReviewPage : UIViewController {
    
    var delegate : StudentMenuDelegate!
    
    override func viewDidLoad() {
        let height = self.view.frame.height
        let width = self.view.frame.width
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let a = UILabel(frame: CGRect(x: 5, y: height * 0.09, width: width, height: height * 0.05))
        a.textAlignment = .Center
        a.font = FONT_Larger2
        a.text = "Task Summary For Katie's Task"
        self.view.addSubview(a)
        
        //add swift chart
        let l = UILabel(frame: CGRect(x: 5, y: height * 0.14, width: width, height: height * 0.05))
        l.text = "Task Accuracy Per Section:"
        l.font = FONT_Larger
        self.view.addSubview(l)
        
        let chart = Chart(frame: CGRect(x: 0, y: height * 0.17, width: width, height: height * 0.4))
        let series = ChartSeries([90, 85, 85, 85, 95, 97, 90, 90, 92, 95, 98, 100, 100, 95, 95])
        
        series.area = true
        series.color = LINE_COLOR_RB2
        chart.gridColor = UIColor.clearColor()
        chart.axesColor = UIColor.clearColor()
        chart.areaAlphaComponent = 0.5
        chart.labelColor = LINE_COLOR_RB2
        chart.addSeries(series)
        self.view.addSubview(chart)
        
        //add stats
        let tView = UITextView(frame: CGRect(x: 0, y: height * 0.58, width: width, height: height * 0.3))
        tView.text = " Notes Hit _\n Notes Missed _\n Note Accuracy Percent _\n Total Delta Time _\n \n Imporovement from last play: _ \n MSE _"
        tView.userInteractionEnabled = false
        tView.font = FONT_Larger
        tView.editable = false
        self.view.addSubview(tView)
        
        //home button
        let button = UIButton(frame: CGRect(x: width * 0.1, y: height * 0.9, width: width * 0.8, height: height * 0.09))
        button.layer.backgroundColor = LINE_COLOR_RB2.CGColor
        button.layer.cornerRadius = 10
        button.setTitle("Home", forState: .Normal)
        button.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        button.addTarget(self, action: #selector(StudentReviewPage.homePressed), forControlEvents: .TouchUpInside)
        self.view.addSubview(button)
        
    }
    
    func homePressed(){
        delegate.student_returnToDash()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
