//
//  StudentDashboardViewContoller.swift
//  448Piano
//
//  Created by William Bertrand on 5/1/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit

protocol StudentMenuDelegate {
    func student_goToPlayView()
    func student_goToChatView()
    func student_goToTasksView()
    func student_goToStoreView()
    func student_returnToDash()
    func student_goToStatsView()
}
class StudentDashboardViewController : UIViewController {
    
    var delegate : StudentMenuDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let width = self.view.frame.width
        let height = self.view.frame.height
        
        let x_inset = width * 0.1
        let y_menu_top = height * 0.2
        
        let y_menu_bottom = height * 0.5
        let menu_height = height * 0.4
        let menu_width = width * 0.35
        
        //image
        let limbaImage = UIImageView(frame: CGRect(x: x_inset, y: height * 0.1, width: width * 0.8, height: height * 0.1))
        limbaImage.image = UIImage(named: "limbaStudent")
        limbaImage.contentMode = .ScaleAspectFit
        self.view.addSubview(limbaImage)
    
        //Play View
        let playButton : UIButton = UIButton(frame: CGRect(x:x_inset, y: y_menu_top, width: menu_width, height: menu_height))
        playButton.setImage(UIImage(named: "menuPlay"), forState: .Normal)
        playButton.imageView?.contentMode = .ScaleAspectFit
        playButton.addTarget(self, action: #selector(StudentDashboardViewController.goToPlayView), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(playButton)
        let l = UILabel(frame: CGRect(x:x_inset, y: y_menu_top + menu_height * 0.67, width: menu_width, height: menu_height * 0.2))
        l.text = "Play"
        l.textAlignment = .Center
        l.font = FONT_Larger2
        l.textColor = LINE_COLOR_RB
        self.view.addSubview(l)
        
        //Tasks View
        let taskButton : UIButton = UIButton(frame: CGRect(x:2 * x_inset + menu_width, y: y_menu_top, width: menu_width, height: menu_height))
        taskButton.setImage(UIImage(named: "menuTasks"), forState: .Normal)
        taskButton.imageView?.contentMode = .ScaleAspectFit
        taskButton.addTarget(self, action: #selector(StudentDashboardViewController.goToTaskView), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(taskButton)
        let l2 = UILabel(frame: CGRect(x:2 * x_inset + menu_width, y: y_menu_top + menu_height * 0.67, width: menu_width, height: menu_height * 0.25))
        l2.text = "Tasks"
        l2.textAlignment = .Center
        l2.font = FONT_Larger2
        l2.textColor = LINE_COLOR_RB
        self.view.addSubview(l2)
        
        
        //Chat View
        let chatButton : UIButton = UIButton(frame: CGRect(x:x_inset, y: y_menu_bottom, width: menu_width, height: menu_height))
        chatButton.setImage(UIImage(named: "menuListen"), forState: .Normal)
        chatButton.imageView?.contentMode = .ScaleAspectFit
        chatButton.addTarget(self, action: #selector(StudentDashboardViewController.goToChatView), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(chatButton)
        let l3 = UILabel(frame: CGRect(x:x_inset, y: y_menu_bottom + menu_height * 0.67, width: menu_width, height: menu_height * 0.25))
        l3.text = "Chat"
        l3.font = FONT_Larger2
        l3.textAlignment = .Center
        l3.textColor = LINE_COLOR_RB
        self.view.addSubview(l3)
        
        
        //Strore View
        let storeButton : UIButton = UIButton(frame: CGRect(x:2 * x_inset + menu_width, y: y_menu_bottom, width: menu_width, height: menu_height))
        storeButton.setImage(UIImage(named: "menuShop"), forState: .Normal)
        storeButton.imageView?.contentMode = .ScaleAspectFit
        storeButton.addTarget(self, action: #selector(StudentDashboardViewController.goToStoreView), forControlEvents: .TouchUpInside)
        
        self.view.addSubview(storeButton)
        let l4 = UILabel(frame: CGRect(x:2 * x_inset + menu_width, y: y_menu_bottom + menu_height * 0.67, width: menu_width, height: menu_height * 0.25))
        l4.text = "Shop"
        l4.font = FONT_Larger2
        l4.textColor = LINE_COLOR_RB
        l4.textAlignment = .Center
        self.view.addSubview(l4)
        
    }
    
    
    func goToPlayView(){
        self.delegate.student_goToPlayView()
    }
    
    func goToTaskView(){
        self.delegate.student_goToTasksView()
    }
    
    func goToStoreView(){
        self.delegate.student_goToStoreView()
    }
    
    func goToChatView(){
        self.delegate.student_goToChatView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
