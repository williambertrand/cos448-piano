import UIKit

class LaunchViewController: UIViewController, HolderViewDelegate {
    
    var holderView : HolderView!
    var limbaView : UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        holderView = HolderView(frame: view.frame)
        limbaView = UIImageView(frame: CGRect(x: view.frame.width * 0.1, y: self.view.frame.height * 0.46, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.12))
        limbaView.alpha = 0.0
        limbaView.contentMode = .ScaleAspectFit
        limbaView.image = UIImage(named: "loading")
        self.view.addSubview(limbaView)
         NSTimer.scheduledTimerWithTimeInterval(0.40, target: self, selector: #selector(LaunchViewController.animateLabel), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(3.0, target:  self, selector: #selector(LaunchViewController.showNextScreen), userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addHolderView()
        holderView.animateSequence()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = self.view.frame
        holderView.parentFrame = self.view.frame
        holderView.delegate = self
        view.addSubview(holderView)
    }
    
    func animateLabel() {
        UIView.animateWithDuration(1.5) {
            self.limbaView.alpha = 1.0
        }
    }
    
    func addButton() {
        let button = UIButton()
        button.frame = CGRectMake(0.0, 0.0, view.bounds.width, view.bounds.height)
        button.addTarget(self, action: "buttonPressed:", forControlEvents: .TouchUpInside)
        view.addSubview(button)
    }
    
    func buttonPressed(sender: UIButton!) {
        view.backgroundColor = Colors.white
        view.subviews.map({ $0.removeFromSuperview() })
        holderView = HolderView(frame: CGRectZero)
        addHolderView()
    }
    
    func showNextScreen(){
//        self.performSegueWithIdentifier("showNextScreen", sender: self)
        
        
//        if teacher account
        self.performSegueWithIdentifier("toTeacherDashBoard", sender: self)
        
    }
    
}//
//  LaunchViewController.swift
//  448Piano
//
//  Created by William Bertrand on 3/29/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
