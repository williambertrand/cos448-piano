////
////  TeacherCalendarView.swift
////  448Piano
////
////  Created by William Bertrand on 4/29/16.
////  Copyright © 2016 William. All rights reserved.
////
//
//import Foundation
//import UIKit
//
//class TeacherCalendarView : UIViewController, UITableViewDelegate, UITableViewDataSource {
//    
//    var calendarTable : UITableView!
//    
//    var sections = ["Today", "Tomorrow", "Wednesday the 4th","Thursday the 5th", "Friday the 6th", "Saturday the 7th", "Sunday the 8th", "Monday the 9th"]
//    var eventsToday : [Event]!
//    var otherEvents : [Event]!
//    
//    let dateFormatter : NSDateFormatter = NSDateFormatter()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        let width = self.view.frame.width
//        let height = self.view.frame.height
//        
//        calendarTable = UITableView(frame: CGRect(x: 0, y: height * 0.05, width: width, height: height * 0.9))
//        calendarTable.delegate = self
//        calendarTable.dataSource = self
//        calendarTable.registerClass(CalendarTableViewCell.self, forCellReuseIdentifier: "calCell")
//        calendarTable.separatorStyle = .None
//        self.view.addSubview(calendarTable)
//        
//        
//        retreiveEventsForUser()
//    }
//    
//    func retreiveEventsForUser(){
//        
//        let ref = Firebase(url: String("https://limba.firebaseio.com/events/" + CURRENT_USER_ID))
//        
//        // Retrieve new posts as they are added to your database
//        ref.observeEventType(.ChildAdded, withBlock: { snapshot in
//            let fbVal = snapshot.value as! Dictionary<String, String>
//            
//            let eDate : NSDate = self.dateFromTimeStamp(Double(fbVal["date"]!)!)
//            
//            let event : Event = Task(senderId: fbVal["senderID"]!, senderDisplayName: fbVal["senderDisplayName"]!, receiverID: fbVal["receiverID"]!, receiverDisplayName: fbVal["receiverDisplayName"]!, assignedDate:aDate, dueDate: dDate, title: fbVal["title"]!, description: fbVal["description"]!, type: nil, status: fbVal["status"]!)
//            
//           
//            
//            //sort event onto proper date
//            
//            self.tasksTable.reloadData()
//        })
//        
//    }
//    
//    func dateFromTimeStamp(timeStamp: Double) -> NSDate{
//        let date : NSDate = NSDate.init(timeIntervalSince1970: timeStamp)
//        return date
//    }
//    
//    
//    //MARK UITABLEVIEW SECTION ---------------------------------------------------------------------------
//    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 7;
//    }
//    
//    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        //overdue
//        
//        return 1
//    }
//    
//    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        var cell : TaskTableViewCell! = self.calendarTable.dequeueReusableCellWithIdentifier("calCell") as! TaskTableViewCell!
//        if cell == nil {
//            cell = CalendatTableViewCell(style: .Default, reuseIdentifier: "calCell")
//        }
//        
//        return cell
//    }
//    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//    }
//    
//    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sections[section]
//    }
//    
//    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return self.view.frame.height * 0.15
//    }
//    
//    
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    func dateForCell(date : NSDate) -> String{
//        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
//        let convertedDate = dateFormatter.stringFromDate(date)
//        return convertedDate
//    }
//    
//}
