//
//  Thread.swift
//  448Piano
//
//  Created by William Bertrand on 4/24/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

class Thread : NSObject {
    var threadID_ : String
    var recentDate_ : NSDate
    var recentText_ : String
    var receiverID_ : String
    var receiverName_ : String
    
    init(threadID: String, receiverID: String, receiverName : String, text: String) {
        self.recentDate_ = NSDate()
        self.recentText_ = text
        self.threadID_ = threadID
        self.receiverID_ = receiverID
        self.receiverName_ = receiverName
    }
    
    func threadID() -> String! {
        return threadID_;
    }
    
    func receiverID() -> String! {
        return receiverID_;
    }
    
    func receiverName() -> String{
        return receiverName_
    }
    
    func recentDate() -> NSDate! {
        return recentDate_;
    }
    
    
    func recentText() -> String! {
        return recentText_;
    }
        
    func receiver() -> String{
        return receiverID_
    }
    
    
}