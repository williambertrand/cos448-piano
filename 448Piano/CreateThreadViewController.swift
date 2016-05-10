//
//  CreateThreadViewController.swift
//  448Piano
//
//  Created by William Bertrand on 4/29/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit

class CreateThreadViewController: UIViewController {
    
    
    var receiverAutoCompleteEntry: AutoCompleteTextField!
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let closeButton = UIButton(frame: CGRect(x: 10, y: self.view.frame.height * 0.04, width: 40, height: 40))
        closeButton.setImage(UIImage(named: "closeIcon"), forState: UIControlState.Normal)
        closeButton.imageView?.contentMode = .ScaleAspectFit
        //add target TODO
        closeButton.addTarget(self, action: #selector(CreateThreadViewController.close), forControlEvents: .TouchUpInside)
        self.view.addSubview(closeButton)
        
        //student name entry
        receiverAutoCompleteEntry.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        receiverAutoCompleteEntry.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)!
        receiverAutoCompleteEntry.autoCompleteCellHeight = 35.0
        receiverAutoCompleteEntry.maximumAutoCompleteCount = 20
        receiverAutoCompleteEntry.hidesWhenSelected = true
        receiverAutoCompleteEntry.hidesWhenEmpty = true
        receiverAutoCompleteEntry.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        receiverAutoCompleteEntry.autoCompleteAttributes = attributes
        receiverAutoCompleteEntry.placeholder = "Student Name"
        
        receiverAutoCompleteEntry.onTextChange = {[weak self] text in
            self!.receiverAutoCompleteEntry.autoCompleteStrings = ["Mary Chen", "Danny Lass", "Michelle Pfiefer", "Meryl Streep", "David Bowie","Katie Hanss","Kaitlin James","Kyle Jordan"]
        
        }
        
        
        //add message textview
        
        //add task button
        
        
        
        
        
    }
    
    func close(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}