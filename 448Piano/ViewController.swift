//
//  ViewController.swift
//  448Piano
//
//  Created by William Bertrand on 3/16/16.
//  Copyright © 2016 William. All rights reserved.
//

import UIKit

class ViewController: UIViewController, TopBarDelegate, SideMenuDelegate, ChatDelegate, LogInDelegate {
    
    var appNavigationController : UINavigationController!
    var menuViewController : SideMenuViewController!
    var menuBar : TopBar!
    var shadowView : UIView!
    var teacherView : TeacherDashboardViewController!
    var chatThreadView : ChatThreadViewController!
    var chatMessagesView : ChatViewController!
    var createTaskView : TeacherTaskCreationViewController!
    var teacherAllTasksView : TeacherAllTasksViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.blueColor()
        appNavigationController.didMoveToParentViewController(self)
        teacherView = UIStoryboard.teacherDashViewController()!;
        chatThreadView = UIStoryboard.chatThreadViewController()!;
        chatMessagesView = UIStoryboard.chatPageViewController()!;
        chatMessagesView.delegate = self;
        chatThreadView.delegate = self
        
        createTaskView = UIStoryboard.createTaskViewController()
        teacherAllTasksView = UIStoryboard.teacherAllTasksViewController()
        //add delegate
        
        //TODO : STUDENT VS TEACHER HERE !!!!!!!!!!!!!!!!!!!!!!!!!!
        
        //add the menu bar
        shadowView = UIView(frame: self.view.frame)
        shadowView.userInteractionEnabled = false
        shadowView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.0)
        view.addSubview(shadowView);
    }
    
    func returnToTeacherDash(){
        appNavigationController.setViewControllers([teacherView], animated: false)
        self.view.addSubview(menuBar);
    }
    
    func returnToChatThreads(){
        appNavigationController.setViewControllers([chatThreadView], animated: false)
        self.view.addSubview(menuBar);
    }
    
    func exitChat(){
        self.returnToChatThreads()
    }
    
    func returnToDash(){
        //if teacher
        self.returnToTeacherDash()
    }
    
    
    func addMenuViewController() {
        if (menuViewController == nil) {
            print("adding menu view controller")
            menuViewController = UIStoryboard.sideMenuViewController()
            menuViewController.delegate = self
            menuViewController.view.frame = (CGRect(x: -self.view.frame.width * 0.6, y: 0, width: self.view.frame.width * 0.4, height: self.view.frame.height))
            addChildSidePanelController(menuViewController!)
        }
    }
    
    func addChildSidePanelController(sideMenu: SideMenuViewController) {
        view.addSubview(sideMenu.view)
        addChildViewController(sideMenu)
        sideMenu.didMoveToParentViewController(self)
    }
    
    func animateSideMenu(){
        //TODO
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showMenu(){
        addMenuViewController()
        UIView.animateWithDuration(0.75) {
            self.menuViewController.view.frame = (CGRect(x: 0, y: 0, width: self.view.frame.width * 0.6, height: self.view.frame.height))
        }
        UIView.animateWithDuration(0.75) {
            self.shadowView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.4)
        }
    }
    
    func hideMenu() {
        UIView.animateWithDuration(0.45) {
            self.menuViewController.view.frame = (CGRect(x: -self.view.frame.width * 0.6, y: 0, width: self.view.frame.width * 0.4, height: self.view.frame.height))
        }
        UIView.animateWithDuration(0.4) {
            self.shadowView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.0)
        }
    }
    
    func hideTopBar(){
        self.menuBar.hidden = true
    }
    func showMenuBar() {
        self.menuBar.hidden = false
    }
    
    func transitionToStudentPage(){
        let studentView : StudentsViewController = UIStoryboard.studentPageViewController()!;
        //TODO : STUDENT VS TEACHER HERE !!!!!!!!!!!!!!!!!!!!!!!!!!
        appNavigationController.setViewControllers([studentView], animated: false)
        print(appNavigationController.viewControllers)
        hideMenu()
    }
    
    func continueToChatView() {
        appNavigationController.setViewControllers([self.chatMessagesView], animated: false)
        print(appNavigationController.viewControllers)
        hideMenu()
        hideTopBar()
    }
    
    func transitionToChatThreadPage() {
        appNavigationController.setViewControllers([chatThreadView], animated: false)
        print(appNavigationController.viewControllers)
        hideMenu() //TODO add if menu is hidden variable
    }
    
    func transitionToCreateTaskPage(){
        appNavigationController.setViewControllers([createTaskView], animated: false)
        print(appNavigationController.viewControllers)
        hideMenu() //TODO add if menu is hidden variable

    }
    
    func transitionToAllTasksPage(){
        appNavigationController.setViewControllers([teacherAllTasksView], animated: false)
        print(appNavigationController.viewControllers)
        hideMenu() //TODO add if menu is hidden variable
    }
    
    func handleLoggedIn(){
        print ("handle login")
        //if user type == TEACHER
        self.appNavigationController?.setViewControllers([teacherView], animated: true)
        print(appNavigationController.viewControllers)
        self.menuBar.hidden = false
    }
    
    func chatView() -> ChatViewController!{
        return self.chatMessagesView
    }

}

private extension UIStoryboard {
    class func mainStoryboard() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: nil) }
    
    class func teacherDashViewController() -> TeacherDashboardViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TeacherDashVC") as? TeacherDashboardViewController
    }
    class func testViewController() -> TestViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TestViewController") as? TestViewController
    }
    class func sideMenuViewController() -> SideMenuViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("SideMenuVC") as? SideMenuViewController
    }
    class func studentPageViewController() -> StudentsViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("StudentsViewController") as? StudentsViewController
    }
    class func chatPageViewController() -> ChatViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("chatPageViewController") as? ChatViewController
    }
    class func chatThreadViewController() -> ChatThreadViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("chatThreadViewController") as? ChatThreadViewController
    }
    class func createTaskViewController() -> TeacherTaskCreationViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("createTaskViewController") as? TeacherTaskCreationViewController
    }
    
    class func teacherAllTasksViewController() -> TeacherAllTasksViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("TeacherAllTasksViewController") as? TeacherAllTasksViewController
    }
}

