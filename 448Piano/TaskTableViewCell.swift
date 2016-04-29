//
//  TaskTableViewCell.swift
//  448Piano
//
//  Created by William Bertrand on 4/29/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit

class TaskTableViewCell: UITableViewCell {

    //keep a ref to task id so firebase can be updated from here
    var taskID : String!
    
    var nameLabel : UILabel!
    var titleLabel : UILabel!
    var infoLabel : UILabel!
    var dueDateLabel : UILabel!
    var notifyButton : UIButton!
    var chatButton : UIButton!
    var addButton : UIButton!
    var deleteButton : UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
        let x_inset = width * 0.05
        let Y_Padding = height * 0.02
        
        
        
        //name
        let nameFrame = CGRect(x: x_inset, y: Y_Padding, width: width / 2, height: height * 0.2)
        nameLabel = UILabel(frame: nameFrame)
        nameLabel.font = FONT
        nameLabel.text = "Student Name"
        self.contentView.addSubview(nameLabel)
        
        //title
        let titleFrame = CGRect(x: x_inset, y: height * 0.22, width: width / 2, height: height * 0.2)
        titleLabel = UILabel(frame: titleFrame)
        titleLabel.text = "Task Title"
        titleLabel.font = FONT_SMALLER
        self.contentView.addSubview(titleLabel)
        
        //due date
        let dueFrame = CGRect(x: width * 0.75, y: height * 0.22, width: width * 0.25, height: height * 0.2)
        dueDateLabel = UILabel(frame: dueFrame)
        dueDateLabel.text = "5/5/16"
        dueDateLabel.font = FONT_SMALLER
        self.contentView.addSubview(dueDateLabel)
        
        //info
        let infoFrame = CGRect(x: x_inset, y: height * 0.42, width: width, height: height * 0.2)
        let infoLabel = UILabel(frame: infoFrame)
        infoLabel.text = "More info on the task"
        infoLabel.font = FONT_SMALLER
        self.contentView.addSubview(infoLabel)
        
        //action buttons
        //let actionFrame = CGRect(x: 0, y: height * 0.62, width: width, height: height * 0.35)
        
        //notfy button
        
        //chat button
        let chatButtonFrame = CGRect(x: width * 0.5, y: height * 0.65, width: width * 0.2, height: height * 0.35)
        chatButton = UIButton(frame: chatButtonFrame)
        chatButton.setImage(UIImage(named: "chatIcon"), forState: .Normal)
        chatButton.addTarget(self, action: #selector(TaskTableViewCell.chatPressed), forControlEvents: .TouchUpInside)
        self.contentView.addSubview(chatButton)
        //add button
        
        //delete button
        
        
    }
    
    func chatPressed(){
        print("Chat")
    }

    
}
