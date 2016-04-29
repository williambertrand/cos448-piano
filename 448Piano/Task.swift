//
//  Task.swift
//  448Piano
//
//  Created by William Bertrand on 4/28/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

enum TaskType {
    case playSong
    case clapSong
    case listenToSong
    case playRightHanded
    case playLeftHanded
}

class Task : NSObject {
    
    var senderId_ : String
    var senderDisplayName_ : String!
    
    var receiverId_ : String
    var receiverDisplayName_ : String!
    
    var assignedDate_ : NSDate
    var dueDate_ : NSDate! //dueDate not required
    
    var description_ : String!
    var title_ : String
    
    var type_ : TaskType
    
    var completionDate_ : NSDate!
    
    var completionDetails_ : NSDictionary!
    
    init(senderId: String, senderDisplayName: String?, receiverID : String, receiverDisplayName: String?, assignedDate: NSDate, dueDate: NSDate?,title:String, description:String?, type : TaskType) {
        self.senderId_ = senderId
        self.senderDisplayName_ = senderDisplayName
        self.receiverId_ = receiverID
        self.receiverDisplayName_ = receiverDisplayName
        self.assignedDate_ = NSDate()
        self.dueDate_ = dueDate
        self.title_ = title
        self.description_ = description
        self.type_ = type
    }
    
    func hasDueDate() -> Bool{
        return (dueDate_ != nil)
    }
    
    func hasDescription() -> Bool{
        return (description_ != nil)
    }
    func hasSenderDisplayName() -> Bool{
        return (senderDisplayName_ != nil)
    }
    func hasReceiverDisplayName() -> Bool{
        return (receiverDisplayName_ != nil)
    }
    
    //completion handling
    
    func setCompletionDate(date:NSDate){
        self.completionDate_ = date
    }
    func setCompletionDetails(dict : NSDictionary){
        self.completionDetails_ = dict
    }
    
}






