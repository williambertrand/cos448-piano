//
//  ChatThreadTableViewCell.swift
//  448Piano
//
//  Created by William Bertrand on 4/24/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation

class ChatThreadTableViewCell: UITableViewCell {
    
    var lastMessage : String!
    var lastTime : String!
    var receiver : String!
    var receiverImageView : UIImageView!
    var nameLabel : UILabel!
    var lineViewBot : UIView!
    var lastMessageLabel : UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.frame = CGRect(x: 0, y: 0, width: 340, height: 70)
        
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
        let x_inset = width * 0.05
        
        //name label for thread
        let nameFrame = CGRect(x: x_inset, y: 5, width: width - x_inset, height: height*0.5)
        nameLabel = UILabel(frame: nameFrame)
        nameLabel.font = FONT_Larger
        if let name = receiver {
            nameLabel.text = name
        }
        else {
            nameLabel.text = "nil name"
        }
        self.contentView.addSubview(nameLabel)
        
        let lineRect = CGRect(x:0, y:0, width: width, height: 1)
        let lineView = UIView(frame: lineRect);
        lineView.backgroundColor = LINE_COLOR_RB2;
        self.contentView.addSubview(lineView)
        let lineRect2 = CGRect(x:0, y:height-1, width: width, height: 1)
        lineViewBot = UIView(frame: lineRect2);
        lineViewBot.backgroundColor = LINE_COLOR_RB2;
        self.contentView.addSubview(lineViewBot)
        
        let timeRect = CGRect(x: width * 0.8, y: 5, width: width * 0.2, height: height * 0.3)
        let timeLabel = UILabel(frame: timeRect)
        timeLabel.font = FONT
        timeLabel.text = "Yesterday"
        self.contentView.addSubview(timeLabel)
        
        
        let lm = CGRect(x: x_inset, y: height - 20, width: width - x_inset, height: height * 0.3)
        lastMessageLabel = UILabel(frame: lm)
        lastMessageLabel.font = FONT
        lastMessageLabel.text = "Hey I need you to do this task for me..."
        self.contentView.addSubview(lastMessageLabel)
        
        
        
        let arrowRect = CGRect(x: width * 0.8, y: height * 0.55, width: width * 0.3, height: height * 0.3)
        let arrowImageView = UIImageView(frame: arrowRect)
        arrowImageView.image = UIImage(named: "rightArrow")
        arrowImageView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(arrowImageView)
        
    }
    
    func setReceiverText(rec:String){
        nameLabel.text = rec
    }
    
}