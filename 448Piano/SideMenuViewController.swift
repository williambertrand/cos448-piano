//
//  SideMenuViewController.swift
//  448Piano
//
//  Created by William Bertrand on 4/22/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit

protocol SideMenuDelegate {
    func hideMenu()
    func transitionToStudentPage()
    func transitionToChatThreadPage()
    func transitionToCreateTaskPage()
    func transitionToAllTasksPage()
    func goToDashBoard()
    func showAboutUs()
    
    //student
    func goToStudentDashboard()
    
}

class SideMenuViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //TableView for items
    
    var delegate : SideMenuDelegate?
    
    var menuTableView : UITableView!
    var titleNameLabel : UILabel!
    
    var menuLabels = ["Dashboard","Account", "Students","Chat","Tasks","New Task","Calendar", "Settings", "Help", "About Us", "Log out"];
    var menuImages = [UIImage(named: "graph"),UIImage(named:"profile"),UIImage(named:"graphStand"),UIImage(named:"chatIcon"), UIImage(named:"clipboard") ,UIImage(named:"edit"), UIImage(named:"Calendar"),UIImage(named:"settingsSwitch"),UIImage(named:"help"),UIImage(named:"letterIcon"), UIImage(named:"logout")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let x_inset = self.view.frame.width * 0.05
        let width = self.view.frame.width
        let height = self.view.frame.height
        let scale : CGFloat = 0.6
        //set up
        
        //add close button 
        let menuDim = self.view.frame.height * 0.05
        let closeButton = UIButton(frame: CGRect(x: x_inset, y: self.view.frame.height * 0.04, width: menuDim, height: self.view.frame.height * 0.04))
        print(closeButton.frame)
        closeButton.setImage(UIImage(named: "closeIcon"), forState: UIControlState.Normal)
        closeButton.imageView?.contentMode = .ScaleAspectFit
        //add target TODO
        closeButton.addTarget(self, action: #selector(SideMenuViewController.close), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        
        //add label
        //add a label showing student/teacher name
        let nameLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.height * 0.05, width: self.view.frame.width * scale - x_inset, height: self.view.frame.height * 0.025))
        nameLabel.text = CURRENT_USER_NAME //TODO change to name
        nameLabel.textAlignment = .Center
        self.view.addSubview(nameLabel)
        
        menuTableView = UITableView(frame: CGRect(x: x_inset, y: height * 0.2, width: width * scale - (4 * x_inset), height: height * 0.8))
        self.menuTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell") // TODO change if want unique cells
        menuTableView.separatorStyle = .None
        menuTableView.scrollEnabled = false
        menuTableView.delegate = self
        menuTableView.dataSource = self
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(menuTableView)
    }
    
    func close(){
        print("closing")
        delegate?.hideMenu()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK Menu UITABLEVIEW SECTION ---------------------------------------------------------------------------
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.menuLabels.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:UITableViewCell = self.menuTableView.dequeueReusableCellWithIdentifier("cell")! as UITableViewCell
        
        //add image
        let icon = UIImageView(frame: CGRect(x:0 , y: (cell.contentView.frame.height / 2) - cell.contentView.frame.width * 0.025, width:cell.contentView.frame.width * 0.05 , height: cell.contentView.frame.width * 0.05))
        icon.contentMode = .ScaleAspectFit
        icon.image = menuImages[indexPath.row]
        cell.contentView.addSubview(icon)
        
        //add label
        let itemLabel = UILabel(frame: CGRect(x:cell.contentView.frame.width * 0.08  , y: (cell.contentView.frame.height / 2) - cell.contentView.frame.width * 0.025, width:cell.contentView.frame.width , height: cell.contentView.frame.width * 0.06))
        itemLabel.text = self.menuLabels[indexPath.row]
        itemLabel.textColor = UIColor.blackColor()
        cell.contentView.addSubview(itemLabel)
        
        
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        //send over to student profile view
        
        //TODO
        //let selectedItem = menuLabels[indexPath.row]
        //handleMenuSelection(selectedItem)
        
    }
    
    func tableView(tableView: UITableView, didHighlightRowAtIndexPath indexPath: NSIndexPath) {
        let selectedItem = menuLabels[indexPath.row]
        handleMenuSelection(selectedItem)
    }
    
    //END UITABLEVIEW SECTION ---------------------------------------------------------------------------

    
    func handleMenuSelection(selectedItem : String) {
        
        if CURRENT_USSER_IS_TEACHER {
            if selectedItem == "Dashboard" {
                delegate?.goToDashBoard()
            }
            else if selectedItem == "Students"{
                delegate?.transitionToStudentPage()
            }
            else if selectedItem == "Chat"{
                delegate?.transitionToChatThreadPage()
            }
            else if selectedItem == "New Task"{
                delegate?.transitionToCreateTaskPage()
            }
            else if selectedItem == "Tasks" {
                delegate?.transitionToAllTasksPage()
            }
            else if selectedItem == "About Us"{
                delegate?.showAboutUs()
            }
            
        }
        else {
            if selectedItem == "Dashboard" {
                delegate?.goToStudentDashboard()
            }
            else if selectedItem == "Students"{
                delegate?.transitionToStudentPage()
            }
            else if selectedItem == "Chat"{
                delegate?.goToStudentDashboard()
            }
            else if selectedItem == "New Task"{
                delegate?.transitionToCreateTaskPage()
            }
            else if selectedItem == "Tasks" {
                delegate?.transitionToAllTasksPage()
            }
        }
        
        
    }
    
    
}