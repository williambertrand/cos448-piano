//
//  TeacherAllTasksViewController.swift
//  448Piano
//
//  Created by William Bertrand on 4/29/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit

class TeacherAllTasksViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tasksTable : UITableView!
    
    var sections = ["OverDue Tasks", "Open Tasks", "Completed Tasks"]
    var overdueTasks : [Task]!
    var openTasks : [Task]!
    var completedTasks : [Task]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        tasksTable = UITableView(frame: CGRect(x: 0, y: height * 0.1, width: width, height: height * 0.9))
        tasksTable.delegate = self
        tasksTable.dataSource = self
        tasksTable.registerClass(ChatThreadTableViewCell.self, forCellReuseIdentifier: "chatCell")
        tasksTable.separatorStyle = .None
        self.view.addSubview(tasksTable)
        
        retreiveTasksForUser()
    }
    
    func retreiveTasksForUser(){
        
    }
    
    
    //MARK UITABLEVIEW SECTION ---------------------------------------------------------------------------
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
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
            return max(completedTasks.count,1)
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : TaskTableViewCell! = self.tasksTable.dequeueReusableCellWithIdentifier("taskCell") as! TaskTableViewCell!
        if cell == nil {
            cell = TaskTableViewCell(style: .Default, reuseIdentifier: "taskCell")
        }
        
//        if indexPath.section == 0 {
//            
//        }
//        else if indexPath.section == 1 {
//            
//        }
//        else if section == 2 {
//            
//        }
        
        if indexPath.row == 0 {
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height * 0.25
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
