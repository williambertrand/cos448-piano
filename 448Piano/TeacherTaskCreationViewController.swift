//
//  TeacherTaskCreationViewController.swift
//  448Piano
//
//  Created by William Bertrand on 4/28/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class TeacherTaskCreationViewController: UIViewController,UITextFieldDelegate {
    
    var newTaskLabel : UILabel!
    
    var titleEntry : UITextField!
    var descriptionEntry : UITextField!
    
    @IBOutlet var receiverAutoCompleteEntry: AutoCompleteTextField!
    var receiverEntry : AutoCompleteTextField!
    
    var dueDateEntry : UIDatePicker!
    
    var delegate : ChatDelegate!
    
    var dueByNextWeekButton : UIButton!
    var dueByNextTwoWeeksButton : UIButton!
    var DUE_IN_WEEK : Bool = false
    var DUE_IN_TWO_WEEKS : Bool = false
    
    //buttons
    var createButton : UIButton!
    var cancelButton : UIButton!
    
    //asd
    var ID_DICT = NSDictionary(dictionary: ["Danny Lass": "dlass","Mary Chen":"mchen","student1":"student1","test student":"student1","Gus":"faf75bf6-eab4-49cd-9c5f-095f4a77d7ba", "Katie Hanss":"0a60c32f-471c-4064-8cbf-51f11f469202"])
    
    //calendar
    var gregCal = NSCalendar.init(calendarIdentifier: NSGregorianCalendar)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let Y_PADDING = self.view.frame.height * 0.05
        let x_inset = self.view.frame.width * 0.1
        let x_width = self.view.frame.width * 0.8
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        
        //new task for : student
        newTaskLabel = UILabel(frame:CGRect(x: x_inset, y: height * 0.1, width: width * 0.8, height: height * 0.05))
        newTaskLabel.text = "New Task"
        newTaskLabel.textAlignment = .Center
        self.view.addSubview(newTaskLabel)
        
        receiverAutoCompleteEntry.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        receiverAutoCompleteEntry.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        receiverAutoCompleteEntry.autoCompleteCellHeight = 35.0
        receiverAutoCompleteEntry.maximumAutoCompleteCount = 20
        receiverAutoCompleteEntry.hidesWhenSelected = true
        receiverAutoCompleteEntry.hidesWhenEmpty = true
        receiverAutoCompleteEntry.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        receiverAutoCompleteEntry.autoCompleteAttributes = attributes
        receiverAutoCompleteEntry.placeholder = "Student Name"
        
        receiverAutoCompleteEntry.onTextChange = {[weak self] text in
            self!.receiverAutoCompleteEntry.autoCompleteStrings = ["Mary Chen","Katie Hanss", "Danny Lass", "Meryl Streep", "David Bowie","Gus"]
        }
        
        
        receiverAutoCompleteEntry.frame = CGRect(x: width * 0.1, y: height * 0.2, width: width * 0.8, height: height * 0.05)
    
        // if CALENDAR_HAS_CURRENT_APPOINTMENT change placeholder
        
        //title 
        titleEntry = UITextField(frame: CGRect(x: x_inset, y: height * 0.27, width: width * 0.6, height: height * 0.05))
        titleEntry.placeholder = "Title"
        self.view.addSubview(titleEntry)
        
        //description
        descriptionEntry = UITextField(frame: CGRect(x: x_inset, y: height * 0.35, width: width, height: height * 0.05))
        descriptionEntry.placeholder = "More Info"
        descriptionEntry.delegate = self
        self.view.addSubview(descriptionEntry)
        
        
        //due date label
        let dueLabel = UILabel(frame:CGRect(x: x_inset, y: height * 0.45, width: width * 0.6, height: height * 0.05))
        dueLabel.text = "Complete By:"
        self.view.addSubview(dueLabel)
        
        //due in buttons
        dueByNextWeekButton = UIButton(frame: CGRect(x: x_inset, y: height * 0.5, width: width * 0.38, height: height * 0.05))
        dueByNextWeekButton.setTitle("Next Week", forState: .Normal)
        dueByNextWeekButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
        dueByNextWeekButton.addTarget(self, action: #selector(TeacherTaskCreationViewController.dueByNextWeekPressed), forControlEvents: .TouchUpInside)
        dueByNextWeekButton.layer.cornerRadius = 5
        dueByNextWeekButton.layer.borderColor = LINE_COLOR_RB2.CGColor
        dueByNextWeekButton.layer.borderWidth = 1
        
        dueByNextTwoWeeksButton = UIButton(frame: CGRect(x: width * 0.52, y: height * 0.5, width: width * 0.38, height: height * 0.05))
        dueByNextTwoWeeksButton.setTitle("Two Weeks", forState: .Normal)
        dueByNextTwoWeeksButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
        dueByNextTwoWeeksButton.addTarget(self, action: #selector(TeacherTaskCreationViewController.dueInTwoWeeksPressed), forControlEvents: .TouchUpInside)
        dueByNextTwoWeeksButton.layer.cornerRadius = 5
        dueByNextTwoWeeksButton.layer.borderColor = LINE_COLOR_RB2.CGColor
        dueByNextTwoWeeksButton.layer.borderWidth = 1
        
        self.view.addSubview(dueByNextWeekButton)
        self.view.addSubview(dueByNextTwoWeeksButton)
        
        //due date
        dueDateEntry = UIDatePicker(frame: CGRect(x: x_inset, y: height * 0.55, width: width * 0.8, height: height * 0.25))
        self.view.addSubview(dueDateEntry)
        
        
        //add task
        createButton = UIButton(frame: CGRect(x: x_inset, y: height * 0.85, width: width * 0.38, height: height * 0.05))
        createButton.setTitle("Create", forState: .Normal)
        createButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        createButton.addTarget(self, action: #selector(TeacherTaskCreationViewController.createTask), forControlEvents: .TouchUpInside)
        createButton.layer.cornerRadius = 5
        createButton.layer.backgroundColor = LINE_COLOR_RB2.CGColor
        self.view.addSubview(createButton)
        
        
        //cancel
        cancelButton = UIButton(frame: CGRect(x: width * 0.52, y: height * 0.85, width: width * 0.38, height: height * 0.05))
        cancelButton.setTitle("Clear", forState: .Normal)
        cancelButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        cancelButton.addTarget(self, action: #selector(TeacherTaskCreationViewController.cancelTask), forControlEvents: .TouchUpInside)
        cancelButton.layer.cornerRadius = 5
        cancelButton.layer.backgroundColor = CANCEL_COLOR_ORG.CGColor
        self.view.addSubview(cancelButton)
        
    }
    
    func returnToChat(){
        print (self.delegate)
        self.delegate.returnToChat()
    }
    
    func dismessSelf(){
        self.receiverEntry = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func dueByNextWeekPressed(){
        let date = NSDate()
        if DUE_IN_WEEK == true {
            DUE_IN_WEEK = false
            dueByNextWeekButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
            dueByNextWeekButton.layer.backgroundColor = UIColor.whiteColor().CGColor
            dueDateEntry.setDate(date, animated: true)
            
        }
        else {
            DUE_IN_WEEK = true
            dueByNextWeekButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            dueByNextWeekButton.layer.backgroundColor = LINE_COLOR_RB2.CGColor
            
            DUE_IN_TWO_WEEKS = false
            dueByNextTwoWeeksButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
            dueByNextTwoWeeksButton.layer.backgroundColor = UIColor.whiteColor().CGColor
            
            dueDateEntry.setDate(dateInOneWeekFrom(date), animated: true)
   
        }
    }
    
    func dueInTwoWeeksPressed(){
        let date = NSDate()
        if DUE_IN_TWO_WEEKS == true {
            DUE_IN_TWO_WEEKS = false
            dueByNextTwoWeeksButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
            dueByNextTwoWeeksButton.layer.backgroundColor = UIColor.whiteColor().CGColor
            dueDateEntry.setDate(date, animated: true)
            
        }
        else{
            DUE_IN_TWO_WEEKS = true
            dueByNextTwoWeeksButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
            dueByNextTwoWeeksButton.layer.backgroundColor = LINE_COLOR_RB2.CGColor
            
            DUE_IN_WEEK = false
            dueByNextWeekButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
            dueByNextWeekButton.layer.backgroundColor = UIColor.whiteColor().CGColor
            
            dueDateEntry.setDate(dateInTwoWeeksFrom(date), animated: true)
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func createTask(){
        
        if DUE_IN_TWO_WEEKS{
            // dueDate = NSDate in two weeks
        }
        else if DUE_IN_WEEK{
            // dueDate = NSDate in one week
        }
        
        sendTaskToFB()
        
    }
    
    func dateInTwoWeeksFrom(date:NSDate) -> NSDate{
        let days = 14.0
        let newDate = date.dateByAddingTimeInterval(60 * 60 * 24 * days)
        return newDate
    }
    
    func dateInOneWeekFrom(date:NSDate)-> NSDate{
        let days = 7.0
        let newDate = date.dateByAddingTimeInterval(60 * 60 * 24 * days)
        return newDate
    }
    
    //TODO DATE PARSING
    func sendTaskToFB() -> Bool{
        //add two taks - one under sender and one under receiver
        let dueDate: String! = nil
        let task_date = NSDate()
        let tasksRefSender = Firebase(url: "https://limba.firebaseio.com/tasks/" + CURRENT_USER_ID)
        let tasksRefRec = Firebase(url: ("https://limba.firebaseio.com/tasks/" + String(userIDFromName(receiverAutoCompleteEntry.text!))))
        var taskObj : Dictionary<String,String>!
        taskObj = ["title":titleEntry.text!,"description":descriptionEntry.text!,"senderID":CURRENT_USER_ID, "senderDisplayName":CURRENT_USER_NAME,"receiverID":receiverAutoCompleteEntry.text!,"receiverDisplayName":receiverAutoCompleteEntry.text!,"AssignedDate": String(task_date.timeIntervalSince1970),"dueDate":String(dueDateEntry.date.timeIntervalSince1970), "status":"open"]
        
        let taskRefSend = tasksRefSender.childByAutoId()
        taskRefSend.setValue(taskObj)
        
        let taskRefRec = tasksRefRec.childByAutoId()
        taskRefRec.setValue(taskObj)
        
        
        let ac = UIAlertController(title: "Task Sent", message: "Your task was sent to \(receiverAutoCompleteEntry.text!)", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.presentViewController(ac, animated: true, completion: { () -> Void in
                //do nothing on completeion
                self.clearTaskFields()
                
                if DID_COME_FROM_CHAT {
//                    self.delegate.returnToChat()
                }
            })
        }
        
        return true
    }
    
    func userIDFromName(name : String) -> String{
        if let val = ID_DICT[name]{
            return val as! String
        }
        else {
            return "newID"
        }
    }
    
    func cancelTask(){
        titleEntry.text = ""
        dueDateEntry.date = NSDate()
        descriptionEntry.text = ""
        receiverAutoCompleteEntry.text = ""
    }
    
    func clearTaskFields(){
        titleEntry.text = ""
        dueDateEntry.date = NSDate()
        descriptionEntry.text = ""
        receiverAutoCompleteEntry.text = ""
    }
    
    func textFieldShouldReturn(textField: UITextField!) -> Bool // called when 'return' key pressed. return NO to ignore.
    {
        textField.resignFirstResponder()
        return true;
    }
    
}