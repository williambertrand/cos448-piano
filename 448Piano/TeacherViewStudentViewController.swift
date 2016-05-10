//
//  TeacherViewStudentViewController.swift
//  448Piano
//
//  Created by William Bertrand on 4/21/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftChart

class TeacherViewStudentViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var taskTableView : UITableView!
    var tasks : NSMutableArray = []
    var scrollView : UIScrollView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let width = self.view.frame.width;
        let height = self.view.frame.height;
        let x_inset = width * 0.1
        
        let totalSize : CGSize = CGSize(width: self.view.frame.width, height:self.view.frame.height * 1.4)
        
        scrollView = UIScrollView(frame: view.bounds);
        
        scrollView.contentSize = totalSize;
        
        //add back button
        let backButton = UIButton(frame:CGRect(x: x_inset * 0.5, y: self.view.frame.height * 0.05, width: self.view.frame.width * 0.15, height: self.view.frame.height * 0.025))
        backButton.setTitle("Back", forState: .Normal);
        backButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
        backButton.addTarget(self, action: #selector(TeacherViewStudentViewController.backToDashboard), forControlEvents: .TouchUpInside)

        
        
        
        //add a label showing student name
        let nameLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height * 0.025, width: self.view.frame.width, height: self.view.frame.height * 0.025))
        nameLabel.text = STUDENT_SELECTED_ID //TODO change to name
        nameLabel.textAlignment = .Center
        scrollView.addSubview(nameLabel)
        
        //add info stuff
        let chartTitleLabel = UILabel(frame: CGRect(x: x_inset, y: self.view.frame.height * 0.05, width: self.view.frame.width * 0.5, height: self.view.frame.height * 0.1))
        chartTitleLabel.text = ("Prev Week For " + STUDENT_SELECTED_ID) //TODO change to name
        chartTitleLabel.textAlignment = .Left
        scrollView.addSubview(chartTitleLabel)
        
        
        let chartHeight = self.view.frame.height * 0.3
        //sample overview chart
        let chartFrame = CGRect(x: 0, y: self.view.frame.height * 0.1, width: width , height: chartHeight);
        let overViewChart = Chart(frame: chartFrame);
        overViewChart.gridColor = UIColor.clearColor()
        overViewChart.axesColor = UIColor.clearColor()
        let series = ChartSeries([0, 6, 2, 8, 4, 7, 3, 10, 8]);
        series.color = LINE_COLOR_RB2;
        overViewChart.addSeries(series);
        overViewChart.highlightLineColor = LINE_COLOR_RB2;
        scrollView.addSubview(overViewChart);
        
        //buttons for time scale
        
        
        //task section
        let task_y = self.view.frame.height * 0.2 + chartHeight;
        let taskLabelFrame = CGRect(x: x_inset, y:task_y , width: width, height: 20)
        let taskLabel = UILabel(frame: taskLabelFrame);
        taskLabel.text = STUDENT_SELECTED_ID + "'s Tasks"
        taskLabel.textColor =  UIColor.blackColor();
        taskLabel.textAlignment = .Left
        scrollView.addSubview(taskLabel)
        
        
        //init tableView
        
        taskTableView = UITableView(frame: CGRect(x: width * 0.1, y: height * 0.6, width: width * 0.8, height: height * 0.4))
        taskTableView.delegate = self;
        taskTableView.dataSource = self;
        taskTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell") // TODO change if want unique cells
        taskTableView.scrollEnabled = false
        scrollView.addSubview(taskTableView);
        

        let str = "https://limba.firebaseio.com/users/" + STUDENT_SELECTED_ID;
        let fbStudent = Firebase(url: str);
        fbStudent.observeSingleEventOfType(.Value, withBlock: {snapshot in
            let student = snapshot.value
            
            let taskDict = student["tasks"] as! NSDictionary
            
            //FB query for each taskID
            for taskID in taskDict.allKeys {
                let taskRef = Firebase(url: "https://limba.firebaseio.com/tasks/" + (taskID as! String))
                taskRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    let task = snapshot.value
                    self.tasks.addObject(task)
                    self.taskTableView.reloadData()
                })
            
            }
            
            }, withCancelBlock: {error in
                print(error.description)
        })
        
        self.view.addSubview(scrollView);
        self.view.addSubview(backButton)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK UITABLEVIEW SECTION ---------------------------------------------------------------------------
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.taskTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let taskname : String = self.tasks[indexPath.row]["title"] as! String
        cell.textLabel?.text = taskname
        
        // cell.detailTextLabel?.text = self.tasks[indexPath.row]["desc"] as! String
        //Aestetics
        // Draw top border only on first cell
        if (indexPath.row == 0) {
            let topLineView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 1))
            topLineView.backgroundColor = LINE_COLOR_RB2;
            cell.contentView.addSubview(topLineView)
        }
        
        let botLineView = UIView(frame: CGRect(x: 0, y: cell.contentView.frame.height - 1, width: self.view.frame.width, height: 1))
        botLineView.backgroundColor = LINE_COLOR_RB2;
        cell.contentView.addSubview(botLineView)
        
        let arrowImage = UIImageView(frame: CGRect(x:cell.contentView.frame.width * 0.85 , y: (cell.contentView.frame.height / 2) - cell.contentView.frame.width * 0.025, width:cell.contentView.frame.width * 0.05 , height: cell.contentView.frame.width * 0.05))
        arrowImage.contentMode = .ScaleAspectFit
        arrowImage.image = UIImage(named: "rightArrow") //TODO - BUG: WHY 2 ARROWS FOR FIRST ENTRY????
        cell.contentView.addSubview(arrowImage)
        
        return cell

    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //send over to student profile view
    }
    
    //END UITABLEVIEW SECTION ---------------------------------------------------------------------------

    
    func backToDashboard(){
        self.performSegueWithIdentifier("backToDashboard", sender: self);
    }
    
}
