//
//  StudentTasksViewController.swift
//  448Piano
//
//  Created by William Bertrand on 5/1/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit

//
//  TeacherAllTasksViewController.swift
//  448Piano
//
//  Created by William Bertrand on 4/29/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import SwiftChart

class StudentTasksViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    var tasksTable : UITableView!
    
    var sections = ["OverDue Tasks", "Open Tasks", "Completed Tasks"]
    var overdueTasks : [Task]!
    var openTasks : [Task]!
    var completedTasks : [Task]!
    
    var scrollView : UIScrollView!
    
    var taskLabel : UILabel!
    
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    
    var width : CGFloat!
    var height : CGFloat!
    var x_inset : CGFloat!
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        width = self.view.frame.width
        height = self.view.frame.height
        x_inset = width * 0.1
        
        taskLabel = UILabel(frame: CGRect(x: x_inset, y: height*0.1, width: width * 0.8, height: height * 0.1))
        taskLabel.font = FONT_Larger
        taskLabel.textAlignment = .Center
        
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.8)
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        
        let taskLabel2 = UILabel(frame: CGRect(x: x_inset, y: height*0.17, width: width, height: height * 0.1))
        taskLabel2.font = FONT
        taskLabel2.text = ("Start with this one to stay on track!")
        self.scrollView.addSubview(taskLabel2)
        
        //create a task view
        
        let l = UILabel(frame: CGRect(x: 5, y: height * 0.46, width: width, height: height * 0.05))
        l.text = "All Tasks"
        l.font = FONT_Larger
        self.scrollView.addSubview(l)
        
        tasksTable = UITableView(frame: CGRect(x: 0, y: height * 0.5, width: width, height: height * 0.9))
        tasksTable.delegate = self
        tasksTable.dataSource = self
        tasksTable.registerClass(StudentTaskTableViewCell.self, forCellReuseIdentifier: "studentTaskCell")
        tasksTable.separatorStyle = .None
        self.scrollView.addSubview(tasksTable)
        
        overdueTasks = [Task]()
        completedTasks = [Task]()
        openTasks = [Task]()
        
        retreiveTasksForUser()
        addTaskCompletetionButtons()
        
        taskLabel.text = ("You have \(openTasks.count) Tasks to complete!")
        
        self.scrollView.addSubview(taskLabel)
        
        addSwiftChartForProjection()
        
    }
    
    func retreiveTasksForUser(){
        
        let ref = Firebase(url: String("https://limba.firebaseio.com/tasks/" + CURRENT_USER_ID))
        
        // Retrieve new posts as they are added to your database
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            print (snapshot.value)
            
            let fbVal = snapshot.value as! Dictionary<String, String>
            let aDate : NSDate = self.dateFromTimeStamp(Double(fbVal["AssignedDate"]!)!)
            let dDate : NSDate = self.dateFromTimeStamp(Double(fbVal["dueDate"]!)!)
            let task : Task = Task(senderId: fbVal["senderID"]!, senderDisplayName: fbVal["senderDisplayName"]!, receiverID: fbVal["receiverID"]!, receiverDisplayName: fbVal["receiverDisplayName"]!, assignedDate:aDate, dueDate: dDate, title: fbVal["title"]!, description: fbVal["description"]!, type: nil, status: fbVal["status"]!)
            
            if task.status() == "over due" {
                self.overdueTasks.append(task)
            }
            else if task.status() == "open" || task.status() == "open "{
                print("Open", task.title_)
                self.openTasks.append(task)
            }
            else if task.status() == "completed"{
                self.completedTasks.append(task)
                print("comp", task.title_)
            }
            
            self.tasksTable.reloadData()
            self.taskLabel.text = ("You have \(self.openTasks.count) Tasks to complete!")
            self.addTaskCompletetionButtons()
            
            
        })
        
    }
    
    func addSwiftChartForProjection(){
        let l = UILabel(frame: CGRect(x: 5, y: height * 1.4, width: width, height: height * 0.05))
        l.text = "This week projection:"
        l.font = FONT_Larger
        self.scrollView.addSubview(l)
        
        let chart = Chart(frame: CGRect(x: 0, y: height * 1.44, width: width, height: height * 0.36))
        let series = ChartSeries([2, 3, 5, 4, 4, 6, 4, 3, 3])
        
        series.area = true
        series.color = LINE_COLOR_RB
        chart.gridColor = UIColor.clearColor()
        chart.axesColor = UIColor.clearColor()
        chart.areaAlphaComponent = 0.5
        chart.labelColor = LINE_COLOR_RB
        chart.addSeries(series)
        self.scrollView.addSubview(chart)
        
        let l2 = UILabel(frame: CGRect(x: 5, y: height * 1.44, width: width, height: height * 0.05))
        l2.text = "**Projection based off 1 weeks historic data**"
        l2.textAlignment = .Center
        l2.font = FONT
        l2.textColor = UIColor.lightGrayColor()
        self.scrollView.addSubview(l2)
    }
    
    func addTaskCompletetionButtons(){
        if num == 0 {
            if openTasks.count > 0 {
                let width = self.view.frame.width
                let height = self.view.frame.height
                let x_inset = width * 0.1
                print("adding button")
                let task1Button = UIView(frame: CGRect(x: x_inset, y: height * 0.25, width: width * 0.8, height: height * 0.12))
                task1Button.layer.backgroundColor = LINE_COLOR_RB.CGColor
                task1Button.layer.cornerRadius = 5
                
                let label = UILabel(frame: CGRect(x: 10, y:0, width: width * 0.4, height: height * 0.07))
                let task = openTasks[0] as Task
                label.text = task.title_
                label.textColor = UIColor.whiteColor()
                task1Button.addSubview(label)
                
                let descLabel = UILabel(frame: CGRect(x: 10, y:23, width: width * 0.6, height: height * 0.07))
                descLabel.text = task.description_
                descLabel.font = FONT_SMALLER
                task1Button.addSubview(descLabel)
                
                let button = UIButton(frame: CGRect(x: width * 0.65, y: 20, width: width * 0.1, height: width * 0.1))
                button.layer.backgroundColor = UIColor.whiteColor().CGColor
                button.layer.cornerRadius = 3
                button.addTarget(self, action: #selector(StudentTasksViewController.completeTask), forControlEvents: .TouchUpInside)
                
                task1Button.addSubview(button)
                
                self.scrollView.addSubview(task1Button)
                num = 1
                
                let moreLabel = UILabel(frame: CGRect(x: x_inset, y:height * 0.35, width: width * 0.8, height: height * 0.1))
                moreLabel.text = "\(openTasks.count + 1) more tasks to complete"
                moreLabel.textAlignment = .Right
                moreLabel.textColor = UIColor.lightGrayColor()
                self.scrollView.addSubview(moreLabel)
            }
            
        }
        
    }
    
    func completeTask(){
        
    }
    
    func dateFromTimeStamp(timeStamp: Double) -> NSDate{
        let date : NSDate = NSDate.init(timeIntervalSince1970: timeStamp)
        return date
    }
    
    
    //MARK UITABLEVIEW SECTION ---------------------------------------------------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //overdue
        if section == 0 {
            return max(overdueTasks.count,1)
        }
            //open
        else if section == 1 {
            return max(openTasks.count,1)
            
        }
            //completed
        else if section == 2 {
            print ("num comp",max(completedTasks.count,1))
            return max(completedTasks.count,1)
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : StudentTaskTableViewCell! = self.tasksTable.dequeueReusableCellWithIdentifier("taskStudentCell") as! StudentTaskTableViewCell!
        if cell == nil {
            cell = StudentTaskTableViewCell(style: .Default, reuseIdentifier: "taskStudentCell")
        }
        
        cell.showAllLabelsAndButton()
        
        if indexPath.section == 0 {
            if overdueTasks.count == 0 {
                cell.clearLabelsAndButtons()
                cell.noTasksLabel.text = "No overDue Tasks"
                
            }
            else {
                let task = overdueTasks[indexPath.row]
                cell.titleLabel.text = task.title_
                cell.nameLabel.text = task.receiverDisplayName_
                cell.infoLabel.text = task.description_
                cell.dueDateLabel.text = dateForCell(task.dueDate_)
                //chatButton add target here?
            }
            
        }
        else if indexPath.section == 1 {
            if openTasks.count == 0 {
                cell.clearLabelsAndButtons()
                cell.noTasksLabel.text = "No Open Tasks"
            }
            else {
                let task = openTasks[indexPath.row]
                cell.titleLabel.text = task.title_
                cell.nameLabel.text = task.receiverDisplayName_
                cell.infoLabel.text = task.description_
                cell.dueDateLabel.text = dateForCell(task.dueDate_)
                //chatButton add target here?
            }
            
        }
        else if indexPath.section == 2 {
            if completedTasks.count == 0 {
                cell.clearLabelsAndButtons()
                cell.noTasksLabel.text = "No Completed Tasks"
            }
            else {
                let task = completedTasks[indexPath.row]
                cell.titleLabel.text = task.title_
                cell.nameLabel.text = task.receiverDisplayName_
                cell.infoLabel.text = task.description_
                cell.dueDateLabel.text = dateForCell(task.dueDate_)
                //chatButton add target here?
            }
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height * 0.15
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateForCell(date : NSDate) -> String{
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        let convertedDate = dateFormatter.stringFromDate(date)
        return convertedDate
    }
    
}

