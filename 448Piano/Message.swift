//
//  Message.swift
//  448Piano
//
//  Created by William Bertrand on 4/23/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import Foundation
import JSQMessagesViewController

//– senderId required method
//– senderDisplayName required method
//– date required method
//– isMediaMessage required method
//– messageHash required method


class Message : NSObject, JSQMessageData {
    
    var senderId_ : String!
    var senderDisplayName_ : String!
    var date_ : NSDate
    var isMediaMessage_ : Bool
    var hash_ : Int = 0
    var text_ : String
    var imageUrl_ : String
    
    init(senderId: String, senderDisplayName: String?, isMediaMessage: Bool, hash: Int, text: String, imageUrl : String) {
        self.senderId_ = senderId
        self.senderDisplayName_ = senderDisplayName
        self.date_ = NSDate()
        self.isMediaMessage_ = isMediaMessage
        self.hash_ = hash
        self.text_ = text
        self.imageUrl_ = imageUrl
    }
    
    func senderId() -> String! {
        return senderId_;
    }
    
    func senderDisplayName() -> String! {
        return senderDisplayName_;
    }
    
    func date() -> NSDate! {
        return date_;
    }
    
    func isMediaMessage() -> Bool {
        return isMediaMessage_;
    }
    
    func messageHash() -> UInt {
        return UInt(hash_);
    }
    
    func text() -> String! {
        return text_;
    }
    
    func imageUrl() -> String  {
        return imageUrl_;
    }
    
}