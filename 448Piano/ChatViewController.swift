//
//  ChatViewController.swift
//  448Piano
//
//  Created by William Bertrand on 4/23/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit
import JSQMessagesViewController
import Firebase


protocol ChatDelegate {
    func exitChat()
    func continueToChatView()
    func transitionToChatThreadPage()
    func returnToDash()
    func showMenuBar()
    func chatView() -> (ChatViewController!)
}
class ChatViewController: JSQMessagesViewController{
    let SEG_FROM_CHAT = "ChatViewBackToThreads"
    
    var dateFormatter = NSDateFormatter()
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: Firebase!
    var messages : [Message] = [Message]()
    var sender : String! //TODO - this is the current user
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    
    var delegate : ChatDelegate!
    //TODO sender Avatar
    
    var incomingBubble : JSQMessagesBubbleImage!
    var outgoingBubble : JSQMessagesBubbleImage!
    
    var senderImageUrl: String!
    
    
    var batchMessages = true
    var ref: Firebase!
    
    
    
    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        messagesRef = Firebase(url: "https://limba.firebaseio.com/messages")
    
        
        
        self.messagesRef.queryOrderedByChild("thread").queryEqualToValue(SELECTED_THREAD_ID).observeEventType(.ChildAdded, withBlock: { snapshot in
            print("xxxxxxxxxxxxxxx")
            print(snapshot.value);
            print("xxxxxxxxxxxxxxx")
            let value : Dictionary <String, AnyObject> = snapshot.value as! Dictionary <String, AnyObject>
            let text = value["text"] as? String
            let sender = value["sender"] as? String
            let imageUrl = value["imageUrl"] as? String
            let message = Message(senderId: sender!, senderDisplayName: sender!, isMediaMessage: false, hash: 10, text: text!, imageUrl: imageUrl!)
            self.messages.append(message)
            self.finishReceivingMessage()
            
        })
        
        print("selected:",SELECTED_THREAD_ID)
        print ("len should be 2:",self.messages.count)
        
        
//        messagesRef.queryLimitedToFirst(25).observeEventType(.ChildAdded, withBlock: { (snapshot) in
//            let text = snapshot.value["text"] as? String
//            let sender = snapshot.value["sender"] as? String
//            let imageUrl = snapshot.value["imageUrl"] as? String
//            
//            print("s:",sender)
//            
//            let message = Message(senderId: sender!, senderDisplayName: sender!, isMediaMessage: false, hash: 10, text: text!, imageUrl: imageUrl!)
//            self.messages.append(message)
//            self.finishReceivingMessage()
//        })
        
    }
    
    //TODO add receiver
    func sendMessage(text: String!, sender: String!,msg_date: NSDate!) {
        let s = String(msg_date.timeIntervalSince1970)
        // *** ADD A MESSAGE TO FIREBASE
        messagesRef = Firebase(url: "https://limba.firebaseio.com/messages")
        messagesRef.childByAutoId().setValue([
            "text":text,
            "sender":sender,
            "imageUrl": " ",
            "receiver":CURRENT_THREAD_RECEIVER,
            "thread":SELECTED_THREAD_ID,
            "timestamp":s
            ])
    }
    
    func setupAvatarImage(name: String, imageUrl: String?, incoming: Bool) {
        if let stringUrl = imageUrl {
            if let url = NSURL(string: stringUrl) {
                if let data = NSData(contentsOfURL: url) {
                    let image = UIImage(data: data)
                    let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
                    let avatarImage = JSQMessagesAvatarImageFactory.avatarImageWithImage(image, diameter: diameter)
                    avatars[name] = avatarImage
                    return
                }
            }
        }
        
        // At some point, we failed at getting the image (probably broken URL), so default to avatarColor
        setupAvatarColor(name, incoming: incoming)
    }
    
    func setupAvatarColor(name: String, incoming: Bool) {
        let diameter = incoming ? UInt(collectionView.collectionViewLayout.incomingAvatarViewSize.width) : UInt(collectionView.collectionViewLayout.outgoingAvatarViewSize.width)
        
        let rgbValue = name.hash
        let r = CGFloat(Float((rgbValue & 0xFF0000) >> 16)/255.0)
        let g = CGFloat(Float((rgbValue & 0xFF00) >> 8)/255.0)
        let b = CGFloat(Float(rgbValue & 0xFF)/255.0)
        let color = UIColor(red: r, green: g, blue: b, alpha: 0.5)
        
        let nameLength = name.characters.count
        let initials : String? = name.substringToIndex(name.startIndex.advancedBy(min(3, nameLength)))
        let userImage = JSQMessagesAvatarImageFactory.avatarImageWithUserInitials(initials, backgroundColor: color, textColor: UIColor.blackColor(), font: UIFont.systemFontOfSize(CGFloat(13)), diameter: diameter)
        avatars[name] = userImage
    }
    
    func backPressed(){
        self.navigationController?.navigationBarHidden = true
        if delegate != nil {
        }
        
        self.delegate.transitionToChatThreadPage()
        
        //performSegueWithIdentifier(SEG_FROM_CHAT, sender: self)
        //self.delegate.exitChat()
    }
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        self.collectionView.frame = CGRect(x: 0, y: self.view.frame.height * 0.2, width: self.view.frame.width, height: self.view.frame.height * 0.9)
        // Do any additional setup after loading the view, typically from a nib.
        inputToolbar.contentView.leftBarButtonItem = nil
        automaticallyScrollsToMostRecentMessage = true
        navigationController?.navigationBar.topItem?.title = "Logout"
//        let backButton = UIButton(frame:CGRect(x: self.view.frame.width * 0.5, y: self.view.frame.height * 0.05, width: self.view.frame.width * 0.15, height: self.view.frame.height * 0.025))
//        backButton.setTitle("Back", forState: .Normal);
//        backButton.addTarget(self, action: #selector(ChatViewController.backPressed), forControlEvents: .TouchUpInside)
        let backButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Rewind, target: self, action: #selector(ChatViewController.backPressed))
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController?.navigationBarHidden = false
        
        sender = (USER_IS_LOGGED_IN) ? CURRENT_USER_ID : "Anonymous"
        self.senderId = CURRENT_USER_ID
        self.senderDisplayName = "First Last"
        
        let profileImageUrl : String! = nil;
        
        if let urlString = profileImageUrl {
            setupAvatarImage(sender, imageUrl: urlString as String, incoming: false)
            senderImageUrl = urlString as String
        } else {
            setupAvatarColor(sender, incoming: false)
            senderImageUrl = ""
        }
        self.incomingBubble = JSQMessagesBubbleImageFactory().incomingMessagesBubbleImageWithColor(CHAT_GRAY_COLOR)
        self.outgoingBubble = JSQMessagesBubbleImageFactory().outgoingMessagesBubbleImageWithColor(LINE_COLOR_RB2)
        setupFirebase()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        collectionView.collectionViewLayout.springinessEnabled = true
    }
    
    
    
    func didPressSendButton(button: UIButton!, withMessageText text: String!, sender: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
//        sendMessage(text, sender: sender)
        finishSendingMessage()
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        sendMessage(text, sender: senderId, msg_date: date)
        finishSendingMessage()
    }
    
    
    //MARK JSQ MESSAGE COLLECTION VIEW SECTION ------------------------------------------------------------------------
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return self.messages[indexPath.item]
    }
    
    
    
//    func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
//        let message = messages[indexPath.item]
//        
//        if message.senderId() == sender {
//            return UIImageView(image: outgoingBubble.messageBubbleImage, highlightedImage: outgoingBubble.messageBubbleHighlightedImage)
//        }
//        
//        return UIImageView(image: incomingBubble.messageBubbleImage, highlightedImage: incomingBubble.messageBubbleHighlightedImage)
//    }
    
    
    func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages[indexPath.item]
        
        if let avatar = avatars[message.senderId()] {
            return UIImageView(image: avatar.avatarImage)
        } else {
            setupAvatarImage(message.senderId(), imageUrl: message.imageUrl(), incoming: true)
            return UIImageView(image:avatars[message.senderId()]?.avatarImage)
        }
        
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages[indexPath.item]
//        if message.senderId() == sender {
//            cell.textView.textColor = UIColor.whiteColor()
//        } else {
//            cell.textView.textColor = UIColor.blackColor()
//        }
        
        let attributes : [String:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor!, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
//        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor!, NSUnderlineStyleAttributeName: 1]
        return cell
    }
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages[indexPath.item];
        
        // Sent by me, skip
        if message.senderId() == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId() == message.senderId() {
                return nil;
            }
        }
        
        return NSAttributedString(string:message.senderId())
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let message = messages[indexPath.item]
        
        // Sent by me, skip
        if message.senderId() == sender {
            return CGFloat(0.0);
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages[indexPath.item - 1];
            if previousMessage.senderId() == message.senderId() {
                return CGFloat(0.0);
            }
        }
        
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item]
        
        if message.senderId() == sender {
            return outgoingBubble
        }
        
        return incomingBubble
        
    }
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    
    //END JSQ MESSAGE COLLECTION VIEW SECTION ------------------------------------------------------------------------
    
    
    func dateToString(date : NSDate) -> String{
         return dateFormatter.stringFromDate(date)
    }
    
    
}