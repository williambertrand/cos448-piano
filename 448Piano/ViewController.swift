//
//  ViewController.swift
//  448Piano
//
//  Created by William Bertrand on 3/16/16.
//  Copyright © 2016 William. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, TopBarDelegate, SideMenuDelegate, ChatDelegate, LogInDelegate, StudentMenuDelegate {
    
    var appNavigationController : UINavigationController!
    var menuViewController : SideMenuViewController!
    var menuBar : TopBar!
    var shadowView : UIView!
    var teacherView : TeacherDashboardViewController!
    var chatThreadView : ChatThreadViewController!
    var chatMessagesView : ChatViewController!
    var createTaskView : TeacherTaskCreationViewController!
    var teacherAllTasksView : TeacherAllTasksViewController!
    var aboutUsPage : LaunchViewController!
    
    //student views
    var studentDashboard : StudentDashboardViewController!
    var studentStoreView : PhotoStreamViewController!
    var studentTasksView : StudentTasksViewController!
    var studentPlayView : StudentPlayView!
    var studentReviewView : StudentReviewPage!
    
    
    
    
    //both
    
    
    
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
        
        aboutUsPage = UIStoryboard.aboutUsViewController()!;
        
        
        studentTasksView = UIStoryboard.studentTasksView()!
        
        studentDashboard = UIStoryboard.studentDashboardViewController()!;
        studentDashboard.delegate = self
        
        studentPlayView = UIStoryboard.studentPlayViewController()!;
        studentPlayView.delegate = self;
        
        studentReviewView = UIStoryboard.studentReviewPage()!;
        studentReviewView.delegate = self;
        
        studentStoreView = UIStoryboard.pianoStoreView()!;
        
        createTaskView = UIStoryboard.createTaskViewController()
        createTaskView.delegate = self
        teacherAllTasksView = UIStoryboard.teacherAllTasksViewController()
        //add delegate        
        
        //add the menu bar
        shadowView = UIView(frame: self.view.frame)
        shadowView.userInteractionEnabled = false
        shadowView.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.0)
        view.addSubview(shadowView);
    }
    
    func goToTaskCreation(){
        if (DID_COME_FROM_CHAT){
            appNavigationController.setViewControllers([self.createTaskView], animated: true)
            let close = UIButton(frame: CGRect(x: 10, y: 60, width: 35, height: 35))
            close.setImage(UIImage(named: "closeIcon"), forState: .Normal)
            close.addTarget(self, action: #selector(TeacherTaskCreationViewController.returnToChat), forControlEvents: .TouchUpInside)
            createTaskView.view.addSubview(close)
        }
    }
    
    func returnToChat(){
        print("close")
        DID_COME_FROM_CHAT = false
        appNavigationController.title = "Create Task"
        self.chatMessagesView.sendTaskMessage()
        self.teacherView.notificationLabel.text = "Katie Completed A Task"
        appNavigationController.setViewControllers([self.chatMessagesView], animated: true)
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
        if CURRENT_USSER_IS_TEACHER{
            self.returnToTeacherDash()
        }
        else{
            hideMenu()
            goToStudentDashboard()
        }
        
    }
    
    func showTaskSummary(){
        self.appNavigationController.setViewControllers([studentReviewView], animated: true)
        self.appNavigationController.navigationBarHidden = true
        self.menuBar.hidden = false
    }
    
    func taskSenderView() -> (TeacherTaskCreationViewController!) {
        let taskSenderView = UIStoryboard.createTaskViewController() as TeacherTaskCreationViewController!
        self.appNavigationController.navigationBarHidden = true
        return taskSenderView
    }
    
    //Student dashboard stuff -----------------------------------------------------------------------------
    func goToStudentDashboard(){
        self.appNavigationController.navigationBarHidden = true
        self.appNavigationController?.setViewControllers([studentDashboard], animated: true)
        self.menuBar.hidden = false
    }
    func student_goToPlayView(){
        self.menuBar.hidden = true
        self.appNavigationController.navigationBarHidden = true
        self.appNavigationController.setViewControllers([studentPlayView], animated: true)
    }
    func student_goToStatsView(){
        self.chatMessagesView.sendTaskCompMessage()
        self.appNavigationController.navigationBarHidden = true
        self.appNavigationController.setViewControllers([studentReviewView], animated: true)
        self.menuBar.hidden = false
    }
    func student_goToChatView(){
        self.appNavigationController.navigationBarHidden = false
        CURRENT_THREAD_RECEIVER = "teacher1"
        SELECTED_THREAD_ID = "threadkh"
        appNavigationController.setViewControllers([self.chatMessagesView], animated: true)
        print("cv",appNavigationController.viewControllers)
        hideMenu()
        hideTopBar()
    }
    func student_goToTasksView(){
        self.appNavigationController.navigationBarHidden = true
        self.appNavigationController.setViewControllers([studentTasksView], animated: true)
    }
    func student_goToStoreView(){
        self.appNavigationController.navigationBarHidden = true
        self.appNavigationController.setViewControllers([studentStoreView], animated: true)
    }
    
    func student_returnToDash(){
        hideMenu()
        self.appNavigationController.navigationBarHidden = true
        self.goToStudentDashboard()
    }
    
    func goToPlayView(){
        self.appNavigationController.navigationBarHidden = true
        student_goToPlayView()
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
    
    func showAboutUs(){
        hideMenu()
        appNavigationController.setViewControllers([aboutUsPage], animated: false)
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
        if menuViewController == nil {
            return
        }
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
        print("sp",appNavigationController.viewControllers)
        hideMenu()
    }
    
    func continueToChatView() {
        appNavigationController.setViewControllers([self.chatMessagesView], animated: false)
        print("cv",appNavigationController.viewControllers)
        hideMenu()
        hideTopBar()
    }
    
    func transitionToChatThreadPage() {
        appNavigationController.setViewControllers([chatThreadView], animated: false)
        print("tp",appNavigationController.viewControllers)
        hideMenu() //TODO add if menu is hidden variable
        self.view.setNeedsDisplay()
    }
    
    func transitionToCreateTaskPage(){
        appNavigationController.setViewControllers([createTaskView], animated: false)
        print("ct",appNavigationController.viewControllers)
        hideMenu() //TODO add if menu is hidden variable
        self.view.setNeedsDisplay()

    }
    
    func transitionToAllTasksPage(){
        appNavigationController.setViewControllers([teacherAllTasksView], animated: false)
        print("AT",appNavigationController.viewControllers)
        hideMenu() //TODO add if menu is hidden variable
        self.loadViewIfNeeded()
    }
    
    func goToDashBoard(){
        //if teacher
        hideMenu()
        self.appNavigationController?.setViewControllers([teacherView], animated: true)
    }
    
    func handleLoggedIn(){
        print ("handle login")
        //if user type == TEACHER
        self.appNavigationController?.setViewControllers([teacherView], animated: true)
        print(appNavigationController.viewControllers)
        self.menuBar.hidden = false
    }
    
    func handleLoggedInTeacher(){
        self.appNavigationController?.setViewControllers([teacherView], animated: true)
        self.menuBar.hidden = false
    }
    
    func handleLoggedInStudent(){
        self.appNavigationController?.setViewControllers([studentDashboard], animated: true)
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
    
    class func studentDashboardViewController() -> StudentDashboardViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("studentDashboardViewController") as? StudentDashboardViewController
    }
    class func studentTasksView() -> StudentTasksViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("studentTasksView") as? StudentTasksViewController
    }
    class func studentPlayViewController() -> StudentPlayView? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("studentPlayViewController") as? StudentPlayView
    }
    class func studentReviewPage() -> StudentReviewPage? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("studentReviewPage") as? StudentReviewPage
    }
    class func aboutUsViewController() -> LaunchViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("launchViewController") as? LaunchViewController
    }
    class func pianoStoreView() -> PhotoStreamViewController? {
        return mainStoryboard().instantiateViewControllerWithIdentifier("storeViewController") as? PhotoStreamViewController
    }
}

