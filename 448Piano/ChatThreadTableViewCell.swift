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
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let width = self.contentView.frame.width
        let height = self.contentView.frame.height
        let x_inset = width * 0.05
        
        //name label for thread
        let nameFrame = CGRect(x: x_inset, y: height * 0.1, width: width - x_inset, height: height*0.8)
        nameLabel = UILabel(frame: nameFrame)
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
        
        let arrowRect = CGRect(x: width * 0.8, y: height * 0.2, width: width * 0.3, height: height * 0.6)
        let arrowImageView = UIImageView(frame: arrowRect)
        arrowImageView.image = UIImage(named: "rightArrow")
        arrowImageView.contentMode = .ScaleAspectFit
        self.contentView.addSubview(arrowImageView)
        
    }
    
    func setReceiverText(rec:String){
        nameLabel.text = rec
    }
    
}