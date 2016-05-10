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

class TeacherAllTasksViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasksTable : UITableView!
    
    var sections = ["OverDue Tasks", "Open Tasks", "Completed Tasks"]
    var overdueTasks : [Task]!
    var openTasks : [Task]!
    var completedTasks : [Task]!
    
    let dateFormatter : NSDateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        tasksTable = UITableView(frame: CGRect(x: 0, y: height * 0.05, width: width, height: height * 0.9))
        tasksTable.delegate = self
        tasksTable.dataSource = self
        tasksTable.registerClass(ChatThreadTableViewCell.self, forCellReuseIdentifier: "chatCell")
        tasksTable.separatorStyle = .None
        self.view.addSubview(tasksTable)
        
        overdueTasks = [Task]()
        completedTasks = [Task]()
        openTasks = [Task]()
        
        retreiveTasksForUser()
        print("abcd")
    }
    
    func retreiveTasksForUser(){
        print (CURRENT_USER_ID)
        let ref = Firebase(url: String("https://limba.firebaseio.com/tasks/" + CURRENT_USER_ID))

        // Retrieve new posts as they are added to your database
        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
            print (snapshot)
            let fbVal = snapshot.value as! Dictionary<String, String>
            
            let aDate : NSDate = self.dateFromTimeStamp(Double(fbVal["AssignedDate"]!)!)
            let dDate : NSDate = self.dateFromTimeStamp(Double(fbVal["dueDate"]!)!)
            let task : Task = Task(senderId: fbVal["senderID"]!, senderDisplayName: fbVal["senderDisplayName"]!, receiverID: fbVal["receiverID"]!, receiverDisplayName: fbVal["receiverDisplayName"]!, assignedDate:aDate, dueDate: dDate, title: fbVal["title"]!, description: fbVal["description"]!, type: nil, status: fbVal["status"]!)
            
            if task.status() == "over due" {
                self.overdueTasks.append(task)
            }
            else if task.status() == "open"{
                print("Open", task.title_)
                self.openTasks.append(task)
            }
            else if task.status() == "completed"{
                self.completedTasks.append(task)
                print("comp", task.title_)
            }
            
            self.tasksTable.reloadData()
        })
        
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
        var cell : TaskTableViewCell! = self.tasksTable.dequeueReusableCellWithIdentifier("taskCell") as! TaskTableViewCell!
        if cell == nil {
            cell = TaskTableViewCell(style: .Default, reuseIdentifier: "taskCell")
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
