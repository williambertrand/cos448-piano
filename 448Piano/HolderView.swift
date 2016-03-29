//
//  HolderView.swift
//  448Piano
//
//  Created by William Bertrand on 3/29/16.
//  Copyright © 2016 William. All rights reserved.
//

import UIKit

protocol HolderViewDelegate:class {
    func animateLabel()
}

class HolderView: UIView {
    
    var parentFrame :CGRect = CGRectZero
    weak var delegate:HolderViewDelegate?
    
    var firstRectangle : UIView!
    var secondRectangle : UIView!
    var thirdRectangle : UIView!
    
    let offset : CGFloat = 0.4
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.clear
        
        print("holder init")
        print(frame.height)
        print(parentFrame.height)
        firstRectangle = UIView(frame: CGRect(x: frame.width * offset, y: frame.height, width: 10, height: 40))
        secondRectangle = UIView(frame: CGRect(x: frame.width * offset + 14, y: frame.height + 5, width: 10, height: 40))
        thirdRectangle = UIView(frame: CGRect(x: frame.width * offset + 28, y: frame.height, width: 10, height: 40))
        
        firstRectangle.backgroundColor = UIColor.blackColor()
        secondRectangle.backgroundColor = UIColor.blackColor()
        thirdRectangle.backgroundColor = UIColor.blackColor()
        self.addSubview(firstRectangle)
        self.addSubview(secondRectangle)
        self.addSubview(thirdRectangle)
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func animateSequence(){
        NSTimer.scheduledTimerWithTimeInterval(0.00, target: self, selector: #selector(HolderView.animateFirstRect), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.20, target: self, selector: #selector(HolderView.animateSecondRect), userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.40, target: self, selector: #selector(HolderView.animateThirdRect), userInfo: nil, repeats: false)
    }
    
    
    func animateFirstRect(){
        print("animating first rec")
        let endFrame = CGRect(x: self.frame.width * offset, y: self.frame.height / 2 - 10, width: 10, height: 40)
        let nextEndFrame = CGRect(x: frame.width * offset , y: frame.height / 2, width: 10, height: 40)
        UIView.animateWithDuration(1.5, animations: {
            self.firstRectangle.frame = endFrame
        }) { (next) in
            UIView.animateWithDuration(0.25, animations: {
                self.firstRectangle.frame = nextEndFrame
            })
            
        }
        
    }
    func animateSecondRect(){
        let endFrame = CGRect(x: frame.width * offset + 14, y: frame.height / 2 - 10, width: 10, height: 40)
        let nextEndFrame = CGRect(x: frame.width * offset + 14, y: frame.height / 2, width: 10, height: 40)
        
        UIView.animateWithDuration(1.5, animations: {
            self.secondRectangle.frame = endFrame
            }) { (next) in
                UIView.animateWithDuration(0.25, animations: {
                    self.secondRectangle.frame = nextEndFrame
                })
                
        }
    }
    func animateThirdRect(){
        let endFrame = CGRect(x: frame.width * offset + 28, y: frame.height / 2 - 10, width: 10, height: 40)
        let nextEndFrame = CGRect(x: frame.width * offset + 28, y: frame.height / 2, width: 10, height: 40)
        
        UIView.animateWithDuration(1.5, animations: {
            self.thirdRectangle.frame = endFrame
        }) { (next) in
            UIView.animateWithDuration(0.25, animations: {
                self.thirdRectangle.frame = nextEndFrame
            })
            
        }
    }
}

