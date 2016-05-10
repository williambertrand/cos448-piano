import UIKit

class LaunchViewController: UIViewController, HolderViewDelegate {
    
    var holderView : HolderView!
    var limbaView : UIImageView!
    var descView: UITextView!
    var height: CGFloat!
    var width : CGFloat!
    
    var mseView : UIImageView!
    
    var scrollView : UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        width = self.view.frame.width
        height = self.view.frame.height
        
        scrollView = UIScrollView(frame: self.view.frame)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: self.view.frame.height * 1.6)
        self.view.addSubview(scrollView)
        
        holderView = HolderView(frame: view.frame)
        limbaView = UIImageView(frame: CGRect(x: view.frame.width * 0.1, y: self.view.frame.height * 0.16, width: self.view.frame.width * 0.8, height: self.view.frame.height * 0.12))
        limbaView.alpha = 0.0
        limbaView.contentMode = .ScaleAspectFit
        limbaView.image = UIImage(named: "loading")
        self.scrollView.addSubview(limbaView)
        
        descView = UITextView(frame: CGRect(x: 0, y: height, width: width, height: height * 0.3))
        descView.text = "We are passionate about helping piano teachers and piano students have a better experience. We seek to connect and engage the the parent, child and teacher in ways that make learning piano fun, rewarding, and organized. \n \nHere's how we track the performance of our student's to see their true, objective approvement over time."
        descView.textAlignment = .Center
        descView.font = FONT
        descView.userInteractionEnabled = false
        self.scrollView.addSubview(descView)
        
        mseView = UIImageView(frame: CGRect(x: 0, y: self.view.frame.height + 300, width: self.view.frame.width, height: self.view.frame.height * 0.4))
        mseView.image = UIImage(named: "mseView")
        mseView.contentMode = .ScaleAspectFit
        scrollView.addSubview(mseView)
        
         NSTimer.scheduledTimerWithTimeInterval(0.40, target: self, selector: #selector(LaunchViewController.animateLabel), userInfo: nil, repeats: false)
        
        NSTimer.scheduledTimerWithTimeInterval(2.5, target: self, selector: #selector(LaunchViewController.showDesc), userInfo: nil, repeats: false)
        
        
//        NSTimer.scheduledTimerWithTimeInterval(3.0, target:  self, selector: #selector(LaunchViewController.showNextScreen), userInfo: nil, repeats: false)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        addHolderView()
        holderView.animateSequence()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showDesc(){
        let nextFrame = CGRect(x: 0, y: height * 0.28, width: width, height: height * 0.3)
        let nextFrameMse = CGRect(x: 0, y: height * 0.5, width: width, height: height * 0.4)
        UIView.animateWithDuration(1.4, animations: {
            self.descView.frame = nextFrame
            self.mseView.frame = nextFrameMse
        })
    }
    
    func addHolderView() {
        let boxSize: CGFloat = 100.0
        holderView.frame = self.view.frame
        holderView.parentFrame = self.view.frame
        holderView.delegate = self
        scrollView.addSubview(holderView)
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
    }
    
}//
//  LaunchViewController.swift
//  448Piano
//
//  Created by William Bertrand on 3/29/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
