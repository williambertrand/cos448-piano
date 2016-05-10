//
//  TeacherDashboard.swift
//  448Piano
//
//  Created by William Bertrand on 4/20/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit
import SwiftChart
import Firebase


class TeacherDashboardViewController : UIViewController, UITableViewDelegate,UITableViewDataSource {
    
    
    var scrollView : UIScrollView!
    
    var overViewChart : Chart!
    
    var chartTitleLabel : UILabel!
    var timeSeriesButton : UIButton!
    var taskSeriesButton : UIButton!
    
    var studentTableView: UITableView!
    var students : NSMutableArray = []
    
    var notificationLabel : UILabel!
    
    
    //series for charts
    let timeSeries = ChartSeries([2, 4, 3, 5, 5, 8, 8, 7, 9]);
    let taskSeries = ChartSeries([4, 3, 2, 6, 8, 6, 7, 9, 7]);
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let Y_PADDING = self.view.frame.height * 0.05
        let x_inset = self.view.frame.width * 0.1
        let x_width = self.view.frame.width * 0.8
        let width = self.view.frame.width
        let height = self.view.frame.height
        let chartHeight = self.view.frame.height * 0.3
        let notHeight = self.view.frame.height * 0.2
        let totalSize : CGSize = CGSize(width: self.view.frame.width, height:self.view.frame.height * 1.4)
        
        scrollView = UIScrollView(frame: view.bounds);
        
        scrollView.contentSize = totalSize;
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //add info stuff
        chartTitleLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height * 0.05, width: self.view.frame.width, height: self.view.frame.height * 0.1))
        chartTitleLabel.textAlignment = .Center
        chartTitleLabel.text = ("Previous Week For All Students") //TODO change to name
        chartTitleLabel.textAlignment = .Center
        scrollView.addSubview(chartTitleLabel)
        
        let timebuttonFrame = CGRect(x: x_inset, y: height * 0.16, width: width * 0.4, height: height * 0.04)
        let taskbuttonFrame = CGRect(x: width * 0.5, y: height * 0.16, width: width * 0.4, height: height * 0.04)
        timeSeriesButton = UIButton(frame: timebuttonFrame)
        taskSeriesButton = UIButton(frame: taskbuttonFrame)
        
        timeSeriesButton.setTitle("Time Played", forState: .Normal)
        taskSeriesButton.setTitle("Tasks Completed", forState: .Normal)
        
        timeSeriesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        taskSeriesButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
        
        timeSeriesButton.layer.backgroundColor = LINE_COLOR_RB2.CGColor
        timeSeriesButton.layer.cornerRadius = 5
        taskSeriesButton.layer.cornerRadius = 5
        
        timeSeriesButton.addTarget(self, action: #selector(TeacherDashboardViewController.viewTimeSeries), forControlEvents: .TouchUpInside)
        taskSeriesButton.addTarget(self, action: #selector(TeacherDashboardViewController.viewTaskSeries), forControlEvents: .TouchUpInside)
        self.scrollView.addSubview(timeSeriesButton)
        self.scrollView.addSubview(taskSeriesButton)
        
        
        //sample overview chart
        let chartFrame = CGRect(x:0, y: self.view.frame.height * 0.2, width: self.view.frame.width, height: chartHeight);
        overViewChart = Chart(frame: chartFrame);
        overViewChart.gridColor = UIColor.clearColor();
        overViewChart.axesColor = UIColor.clearColor()
        overViewChart.labelColor = UIColor.clearColor()
    
        
        timeSeries.color = LINE_COLOR_RB2;
        taskSeries.color = LINE_COLOR_RB2;
        
        overViewChart.addSeries(timeSeries);
        overViewChart.highlightLineColor = LINE_COLOR_RB2;
        scrollView.addSubview(overViewChart);
        
        //buttons for graph
        
        //above
        
        //below
        
        
        //notifications
        
        let notifyFrame = CGRect(x: x_inset, y: self.view.frame.height * 0.5, width: x_width, height: notHeight);
        
        let notifyViewPlaceHolder = UIView(frame: notifyFrame);
        
        notificationLabel = UILabel(frame: CGRect(x: 0, y: 0, width: x_width, height: notHeight))
        notificationLabel.text = "0 New Notifications"
        notificationLabel.textColor =  UIColor.whiteColor();
        notificationLabel.textAlignment = .Center
        
        notifyViewPlaceHolder.layer.cornerRadius = 10
        notifyViewPlaceHolder.backgroundColor = LINE_COLOR_RB2_5
        notifyViewPlaceHolder.addSubview(notificationLabel);
        scrollView.addSubview(notifyViewPlaceHolder);

        
        //student section
        let student_y = self.view.frame.height * 0.15 + chartHeight + notHeight + 2.0 * Y_PADDING;
        let studentLabelFrame = CGRect(x: x_inset, y:student_y , width: x_width, height: 20)
        let studentLabel = UILabel(frame: studentLabelFrame);
        studentLabel.text = "Students"
        studentLabel.textColor =  UIColor.blackColor();
        studentLabel.textAlignment = .Left
        scrollView.addSubview(studentLabel)
        
        
        let tableY = student_y + studentLabel.frame.height + (Y_PADDING / 2);
        studentTableView = UITableView(frame: CGRect(x: x_inset, y: tableY, width: x_width, height: self.view.frame.height * 0.4))
        studentTableView.delegate = self;
        studentTableView.dataSource = self;
        studentTableView.scrollEnabled = false;
        studentTableView.separatorStyle = .None;
        self.studentTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell") // TODO change if want unique cells
        
            
        scrollView.addSubview(studentTableView)
            
        //add the scroll view
        self.view.addSubview(scrollView);
        
//        let nav = TopBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height * 0.08))
//        self.view.addSubview(nav)
        
        retreiveStudentList();
        //let ref = Firebase(url: "https://limba.firebaseio.com/")
        
    }
    
    func viewTimeSeries(){
        print("ime")
        timeSeriesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        taskSeriesButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
        timeSeriesButton.layer.backgroundColor = LINE_COLOR_RB2.CGColor
        taskSeriesButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        overViewChart.removeSeries()
        overViewChart.addSeries(timeSeries)
        overViewChart.setNeedsDisplay()
        
    }
    
    func viewTaskSeries(){
        print("task")
        taskSeriesButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        timeSeriesButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
        taskSeriesButton.layer.backgroundColor = LINE_COLOR_RB2.CGColor
        timeSeriesButton.layer.backgroundColor = UIColor.whiteColor().CGColor
        overViewChart.removeSeries()
        overViewChart.addSeries(taskSeries)
        overViewChart.setNeedsDisplay()
    }
    
    
    
    func retreiveStudentList(){
        let fbTest = Firebase(url: "https://limba.firebaseio.com/users/teacher1");
        
        // Attach a closure to read the data at our posts reference
        fbTest.observeSingleEventOfType(.Value, withBlock: { snapshot in
            let user : NSDictionary = snapshot.value as! NSDictionary
            let studentDict : NSDictionary = user["students"] as! NSDictionary
            let studentList : [AnyObject] = studentDict.allKeys
            print(studentDict.allKeys)
            for username in studentList {
                let str = "https://limba.firebaseio.com/users/" + (username as! String);
                let fbStudent = Firebase(url: str);
                fbStudent.observeSingleEventOfType(.Value, withBlock: {snapshot in
                    let student = snapshot.value
                    print(snapshot.value)
                    print("cccc")
                    self.students.addObject(student)
                    self.studentTableView.reloadData()
                    }, withCancelBlock: {error in
                        print(error.description)
                })
            }
            
            
            }, withCancelBlock: { error in
                print(error.description)
        })
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    //MARK UITABLEVIEW SECTION ---------------------------------------------------------------------------
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.students.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.studentTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        let studentName : String = self.students[indexPath.row]["name"] as! String
        cell.textLabel?.text = studentName
        
        
        
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
            let studentID : String = self.students[indexPath.row]["ID"] as! String
            STUDENT_SELECTED_ID = studentID
            self.performSegueWithIdentifier("teacherDashToStudentProf", sender: self)
        
    }
    
    //END UITABLEVIEW SECTION ---------------------------------------------------------------------------

    
}