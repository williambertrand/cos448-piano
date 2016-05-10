//
//  StudentPlayView.swift
//  448Piano
//
//  Created by William Bertrand on 5/2/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

class StudentPlayView: UIViewController {
    var scrollImage : UIImageView!
    var delegate : StudentMenuDelegate!
    var micButton : UIButton!
    var alphaLine : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //display alert
        let ac = UIAlertController(title: "Play!", message: "Please Turn Phone Sideways to Play", preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        
        NSOperationQueue.mainQueue().addOperationWithBlock { () -> Void in
            self.presentViewController(ac, animated: true, completion: { () -> Void in
                //animate on completeion
                
            })
        }
        
        //record button
        micButton = UIButton(frame: CGRect(x: 10, y: 70, width: 60, height: 60))
        micButton.setBackgroundImage(UIImage(named: "micButton"), forState: .Normal)
        micButton.addTarget(self, action: #selector(StudentPlayView.animateScrollPiece), forControlEvents: .TouchUpInside)
        self.view.addSubview(micButton)
        
        //scrollPianoImage
        scrollImage = UIImageView(frame:CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 4000))
        scrollImage.image = UIImage(named: "scrollSong")
        self.view.addSubview(scrollImage)
        
        
        //alpha-line
        alphaLine = UIView(frame: CGRect(x: 40, y: self.view.frame.height * 0.25, width: self.view.frame.width - 80, height: 10))
        alphaLine.layer.backgroundColor = ALPHA_COLOR_RED.CGColor
        alphaLine.layer.cornerRadius = 4
        self.view.addSubview(alphaLine)
        
        //scoreLabel
        
        //notesLabel
        
        //animate
        
        
        
    }
    
    func animateScrollPiece(){
        self.micButton.hidden = true
        UIView.setAnimationCurve(UIViewAnimationCurve.Linear)
        let nextFrame = CGRect(x: 0, y: -4000, width:self.view.frame.width , height: 4000)
        
        UIView.animateWithDuration(50.0, animations: {self.scrollImage.frame = nextFrame})
        
        NSTimer.scheduledTimerWithTimeInterval(48.5, target:  self, selector: #selector(StudentPlayView.addDoneButton), userInfo: nil, repeats: false)
    }
    
    func addDoneButton(){
        self.alphaLine.hidden = true
        let doneButton = UIButton(frame: CGRect(x: self.view.frame.width - self.view.frame.height * 0.25, y: self.view.frame.height * 0.45, width: self.view.frame.height * 0.3, height: self.view.frame.width * 0.1))
        doneButton.layer.cornerRadius = 10
        doneButton.layer.backgroundColor = LINE_COLOR_RB.CGColor
        doneButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        doneButton.setTitle("Done!", forState: .Normal)
        doneButton.addTarget(self, action: #selector(StudentPlayView.done), forControlEvents: .TouchUpInside)
        doneButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        self.view.addSubview(doneButton)
        
        let againButton = UIButton(frame: CGRect(x: self.view.frame.width - self.view.frame.height * 0.45, y: self.view.frame.height * 0.45, width: self.view.frame.height * 0.3, height: self.view.frame.width * 0.1))
        againButton.layer.cornerRadius = 10
        againButton.layer.backgroundColor = CANCEL_COLOR_ORG.CGColor
        againButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        againButton.setTitle("Play Again!", forState: .Normal)
        againButton.addTarget(self, action: #selector(StudentPlayView.done), forControlEvents: .TouchUpInside)
        againButton.transform = CGAffineTransformMakeRotation(CGFloat(M_PI_2))
        self.view.addSubview(againButton)
    }
    
    func done(){
        self.delegate.student_goToStatsView()
//        self.delegate.student_returnToDash()
        //self.delegate.showStatsView() swiftCharts? photo? //TODODOODODODODODODO
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}