//
//  LogInSignUpScreen.swift
//  448Piano
//
//  Created by William Bertrand on 4/27/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit
import Firebase

protocol LogInDelegate {
    func handleLoggedIn()
    func handleLoggedInStudent()
    func handleLoggedInTeacher()
}

class LogInSignUpScreen: UIViewController, UITextFieldDelegate {
    
    let ref = Firebase(url: "https://limba.firebaseio.com")
    
    var delegate : LogInDelegate!
    
    //scrollingView of faces
    var scrollingView1: UIImageView!
    var scrollingView2: UIImageView!
    
    //sing up and log in buttons
    var singUpButton : UIButton!
    var logInButton : UIButton!
    
    //forms
    var usernameEntry : UITextField!
    var userPasswordEntry : UITextField!
    
    
    //variables
    var width : CGFloat!
    var height : CGFloat!
    var viewWidth : CGFloat!
    var viewHeight : CGFloat!
    var viewY : CGFloat!
    var x_inset : CGFloat!
    var butWidth : CGFloat!
    var butHeight : CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        width = self.view.frame.width
        height = self.view.frame.height
        viewWidth = 1000.0
        viewHeight = 250.0
        viewY  = height * 0.6
        x_inset = width * 0.08
        let text_inset = width * 0.25
        
        butWidth = width * 0.84
        butHeight = height * 0.05
        
        
        //image
        let limbaFrame = CGRect(x: width * 0.5 - 90, y: 50, width: 220, height: 220)
        let limbaImage = UIImageView(frame: limbaFrame)
        limbaImage.image = UIImage(named: "limbacolor")
        limbaImage.contentMode = .ScaleAspectFit
        self.view.addSubview(limbaImage)
    
        
        //add scroll views
        scrollingView1 = UIImageView(frame: CGRect(x: 0, y: viewY, width: viewWidth, height: viewHeight))
        scrollingView2 = UIImageView(frame: CGRect(x: viewWidth, y: viewY, width: viewWidth, height: viewHeight))
        scrollingView1.image=UIImage(named: "faces")
        scrollingView2.image=UIImage(named: "faces")
        
        scrollingView1.contentMode = .ScaleAspectFit
        scrollingView2.contentMode = .ScaleAspectFit
        
        self.view.addSubview(scrollingView1)
        self.view.addSubview(scrollingView2)
        
        
        let usernameFrame = CGRect(x: text_inset, y: height * 0.3, width: width * 0.5, height: butHeight / 2)
        let passwordFrame = CGRect(x: text_inset, y: height * 0.3 + (butHeight / 1.5), width: width * 0.5, height: butHeight / 2)
        //text fields
        usernameEntry = UITextField(frame: usernameFrame)
        userPasswordEntry = UITextField(frame: passwordFrame)
        usernameEntry.placeholder = "email"
        userPasswordEntry.placeholder="password"
        usernameEntry.textAlignment = .Center
        userPasswordEntry.textAlignment = .Center
        userPasswordEntry.delegate = self
        
        self.view.addSubview(usernameEntry)
        self.view.addSubview(userPasswordEntry)
        
        
        //buttons
        
        logInButton = UIButton(frame: CGRect(x: x_inset, y: height * 0.5, width: butWidth, height: butHeight))
        logInButton.layer.cornerRadius = 15;
        logInButton.layer.backgroundColor = UIColor.clearColor().CGColor
        logInButton.layer.borderWidth = 2
        logInButton.layer.borderColor = LINE_COLOR_RB.CGColor
        logInButton.addTarget(self, action: #selector(LogInSignUpScreen.loginPressed), forControlEvents: .TouchUpInside)
        
        logInButton.setTitle("Log In", forState: .Normal)
        logInButton.setTitleColor(LINE_COLOR_RB, forState: .Normal)
        self.view.addSubview(logInButton)
        
        singUpButton = UIButton(frame: CGRect(x: x_inset, y: height * 0.5 + butHeight + height * 0.02, width: butWidth, height: butHeight))
        singUpButton.layer.cornerRadius = 15;
        singUpButton.layer.backgroundColor = UIColor.clearColor().CGColor
        singUpButton.layer.borderWidth = 2
        singUpButton.layer.borderColor = LINE_COLOR_RB2.CGColor
        singUpButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
        singUpButton.setTitle("Sign Up", forState: .Normal)
        singUpButton.addTarget(self, action: #selector(LogInSignUpScreen.singUpPressed), forControlEvents: .TouchUpInside)
        self.view.addSubview(singUpButton)
        
        
        //testButtons:
        let teacherTest = UIButton(frame: CGRect(x: 0, y: 20, width: 80, height: 15))
        teacherTest.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        teacherTest.setTitle("Test Tee", forState: .Normal)
        teacherTest.addTarget(self, action: #selector(LogInSignUpScreen.testTeacherLogin), forControlEvents: .TouchUpInside)
        self.view.addSubview(teacherTest)
        
        let studentTest = UIButton(frame: CGRect(x: 0, y: 35, width: 80, height: 15))
        studentTest.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
        studentTest.setTitle("Test stuuu", forState: .Normal)
        studentTest.addTarget(self, action: #selector(LogInSignUpScreen.testStudentLogin), forControlEvents: .TouchUpInside)
        self.view.addSubview(studentTest)
        
        
        //copyright
        let cprLabel = UILabel(frame: CGRect(x: width/2 - 55, y: height - 20, width: 110, height: 20))
        cprLabel.text = "© 2016 Limba"
        cprLabel.textColor = UIColor.lightGrayColor()
        cprLabel.textAlignment = .Center
        self.view.addSubview(cprLabel)
        
        animateScrolls1()
        
//add random music notes..... extra
//        for i in 0...20 {
//            print(i)
//            let randX = CGFloat(arc4random_uniform(UInt32(width) - 50) + UInt32(width * 0.05))
//            let randY = CGFloat(arc4random_uniform(UInt32(height) - 50) + UInt32(height * 0.25))
//            var x = UIImageView(frame: CGRect(x: randX, y: randY, width: 40, height: 40))
//            x.image = UIImage(named:"musicNote")
//            self.view.addSubview(x)
//        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func animateScrolls1(){
        let width = self.view.frame.width
        let height = self.view.frame.height
        let viewWidth : CGFloat = 1000.0
        let viewHeight : CGFloat = 250.0
        let viewY : CGFloat = height * 0.6
        
//        UIView.animateWithDuration(5.0) { 
//            self.scrollingView1.frame = CGRect(x: -width, y: viewY, width: viewWidth, height: viewHeight)
//        }
        
        UIView.animateWithDuration(21.0, animations: {
            
            self.scrollingView1.frame = CGRect(x: -viewWidth, y: viewY, width: viewWidth, height: viewHeight)
            self.scrollingView2.frame = CGRect(x: 0, y: viewY, width: viewWidth, height: viewHeight)
            
            }, completion: { (comp) in
                self.scrollingView1.frame = CGRect(x: 0, y: viewY, width: viewWidth, height: viewHeight)
                self.scrollingView2.frame = CGRect(x: viewWidth, y: viewY, width: viewWidth, height: viewHeight)
//                self.animateScrolls1();
        })
        
        
    }
    
    func animateScrolls2(){
        let width = self.view.frame.width
        let height = self.view.frame.height
        let viewWidth : CGFloat = 1000.0
        let viewHeight : CGFloat = 250.0
        let viewY : CGFloat = height * 0.6
        
        UIView.animateWithDuration(21.0, animations: {
            self.scrollingView2.frame = CGRect(x: -viewWidth, y: viewY, width: viewWidth, height: viewHeight)
        }) { (error) in
            self.scrollingView2.frame = CGRect(x: width, y: viewY, width: viewWidth, height: viewHeight)
            self.animateScrolls1()
        }
        
    }
    
    
    func showLogInPressed(){
        UIView.animateWithDuration(0.5, animations: {
            self.singUpButton.frame = CGRect(x: self.x_inset, y: self.height * 0.1, width: self.butWidth, height: self.butHeight)
            self.singUpButton.alpha = 0.0
            
            self.usernameEntry.frame = CGRect(x: self.x_inset, y: self.height * 0.5 + self.height * 0.02, width: self.butWidth, height: self.butHeight)
            self.userPasswordEntry.frame = CGRect(x: self.x_inset, y: self.height * 0.5 + self.height * 0.02, width: self.butWidth, height: self.butHeight)
            
            
        }) { (error) in
            
        }

    }
    
    func loginPressed(){
        let username = usernameEntry.text
        let password = userPasswordEntry.text
        
        self.logInButton.layer.backgroundColor = LINE_COLOR_RB2.CGColor
        self.logInButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        ref.authUser(username, password: password) {
            error, authData in
            if error != nil {
                // an error occured while attempting login
                self.logInButton.layer.backgroundColor = UIColor.whiteColor().CGColor
                self.logInButton.setTitleColor(LINE_COLOR_RB2, forState: .Normal)
                
                self.delegate.handleLoggedIn()
            } else {
                // user is logged in, check authData for data
                let ref2 = Firebase(url: ("https://limba.firebaseio.com/users/" + authData.uid))
                
                ref2.observeEventType(.Value, withBlock: {snapshot in
                    print(snapshot.value)
                    let user : NSDictionary = snapshot.value as! NSDictionary
                    let type : String = user["type"] as! String
                    CURRENT_USER_NAME = user["name"] as! String
                    CURRENT_USER_ID = authData.uid
                    print(CURRENT_USER_NAME)
                    if type == "student" {
                        CURRENT_USSER_IS_TEACHER = false
                        self.delegate.handleLoggedInStudent()
                    }
                    else {
                        CURRENT_USSER_IS_TEACHER = true
                        self.delegate.handleLoggedInTeacher()
                    }
                    
                    
                })
                
            }
        }
        
        
    }
    
    func singUpPressed(){
        singUpButton.layer.backgroundColor = LINE_COLOR_RB2.CGColor
    }
    
    
    //MARK UITEXTVIEWDELEGATE METHODS ----
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField == self.userPasswordEntry {
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        if textField == self.userPasswordEntry {
            self.resignFirstResponder()
    
        }
    }
    
    func testTeacherLogin(){
        ref.authUser("a@bc.com", password: "pass") {
            error, authData in
            if error != nil {
                // an error occured while attempting login
            } else {
                // user is logged in, check authData for data
                CURRENT_USER_ID = "teacher1"
                CURRENT_USSER_IS_TEACHER = true
                self.delegate.handleLoggedInTeacher()
                
            }
        }

        
    }
    
    func testStudentLogin(){
        ref.authUser("kh@abc.com", password: "pass") {
            error, authData in
            if error != nil {
                // an error occured while attempting login
            } else {
                // user is logged in, check authData for data
                CURRENT_USSER_IS_TEACHER = false
                CURRENT_USER_ID = authData.uid
                self.delegate.handleLoggedInStudent()
                
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}