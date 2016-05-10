//
//  ChatThreadViewController.swift
//  448Piano
//
//  Created by William Bertrand on 4/24/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit
import Firebase
//TODO

var CURRENT_THREAD_RECEIVER: String!

//Just a full screen custom UITABLEVIEW
class ChatThreadViewController : UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    let SEG_TO_CHAT = "FromThreadsToChatView"
    let SEG_FROM_CHAT = "ChatViewBackToThreads"
    
    var threads : [Thread] = [Thread]()
    var threadTable : UITableView!
    
    var delegate: ChatDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        threadTable = UITableView(frame: CGRect(x: 0, y: height * 0.1, width: width, height: height * 0.8))
        threadTable.delegate = self
        threadTable.dataSource = self
        threadTable.registerClass(ChatThreadTableViewCell.self, forCellReuseIdentifier: "chatCell")
        threadTable.separatorStyle = .None
        self.view.addSubview(threadTable)
        
        let butFrame = CGRect(x: width * 0.4, y: height * 0.85, width: width * 0.15, height: height * 0.1)
        let plusButton = UIButton(frame: butFrame)
        plusButton.setImage(UIImage(named: "plus"), forState: .Normal)
        plusButton.imageView?.contentMode = .ScaleAspectFit
        plusButton.addTarget(self, action: #selector(ChatThreadViewController.createNewThread), forControlEvents: .TouchUpInside)
        self.view.addSubview(plusButton)
        
        retreiveThreadsForUser()
    }
    
    override func viewDidAppear(animated: Bool) {
        print("this could work")
//        self.delegate.showMenuBar()
        //delegate null
    }
    
    override func viewWillAppear(animated: Bool) {
        print("this will work better")
        self.delegate.showMenuBar()
    }
    
    
    func retreiveThreadsForUser(){
        let refStr = "https://limba.firebaseio.com/users/" + CURRENT_USER_ID
        
        let threadRef = Firebase(url: refStr)
        threadRef.observeEventType(.Value, withBlock: { (snapshot) in
            print (snapshot.value)
            let threadDict = snapshot.value["threads"] as! NSDictionary
            print ("----------")
            for thread in threadDict.allKeys {
                //get more thread info
                print(thread)
//                let th = thread as! String
                print (thread)
                let recID = threadDict[String(thread)]!["receiverID"] as! String
                let recName = threadDict[String(thread)]!["receiver"] as! String
                self.threads.append(Thread(threadID: thread as! String, receiverID: recID, receiverName: recName, text: "latest message"))
                self.threadTable.reloadData()
            }
            print (self.threads.count)
            
        })
        
    }
    
    //create a new thread       //SEARCH VIEW AS WELL
    func createNewThread(){
        //show popover view
        let vc : CreateThreadViewController = CreateThreadViewController(nibName: nil, bundle: nil)
        self.presentViewController(vc, animated: true, completion: nil)
        //add ref to firebase
    }
    
    
    
    func selectedThread(threadID: String){
        delegate.continueToChatView()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK UITABLEVIEW SECTION ---------------------------------------------------------------------------
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.threads.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : ChatThreadTableViewCell! = self.threadTable.dequeueReusableCellWithIdentifier("chatCell") as! ChatThreadTableViewCell!
        if cell == nil {
            cell = ChatThreadTableViewCell(style: .Default, reuseIdentifier: "chatCell")
        }
        if indexPath.row == 0 {
            cell.lineViewBot.backgroundColor = UIColor.clearColor()
            cell.lastMessageLabel.text = "Hey Katie!"
        }
        if indexPath.row == 1 {
            cell.lastMessageLabel.text = "Danny did you get that task done?!"
        }
        CURRENT_THREAD_RECEIVER = threads[indexPath.row].receiver()
        cell.setReceiverText(threads[indexPath.row].receiverName())
        return cell
    }
    
//    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
//        STUDENT_SELECTED_ID = self.threads[indexPath.row].receiver()
//        SELECTED_THREAD_ID = self.threads[indexPath.row].threadID()
//        delegate.continueToChatView()
//        self.performSegueWithIdentifier(SEG_TO_CHAT, sender: self)
//        
//    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        STUDENT_SELECTED_ID = self.threads[indexPath.row].receiver()
        SELECTED_THREAD_ID = self.threads[indexPath.row].threadID()
        CURRENT_THREAD_RECEIVER = self.threads[indexPath.row].receiver()
        self.selectedThread(self.threads[indexPath.row].threadID())
        print("selected", threads[indexPath.row].receiver())
//        self.delegate.continueToChatView()
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
    //END UITABLEVIEW SECTION ---------------------------------------------------------------------------
    
    
}