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
    func taskSenderView() ->(TeacherTaskCreationViewController!)
    func goToTaskCreation()
    func returnToChat()
    func goToPlayView()
    func showTaskSummary()
}

class ChatViewController: JSQMessagesViewController, UIImagePickerControllerDelegate{
    let SEG_FROM_CHAT = "ChatViewBackToThreads"
    
    var dateFormatter = NSDateFormatter()
    
    // *** STEP 1: STORE FIREBASE REFERENCES
    var messagesRef: Firebase!
    var messages : [JSQMessage]?
    
    var photoItems : [JSQPhotoMediaItem]?
    
    var taskItems : [JSQPhotoMediaItem]?
    var sender : String! //TODO - this is the current user
    var avatars = Dictionary<String, JSQMessagesAvatarImage>()
    
    var delegate : ChatDelegate!
    //TODO sender Avatar
    
    var incomingBubble : JSQMessagesBubbleImage!
    var outgoingBubble : JSQMessagesBubbleImage!
    
    var incomingAvatar: JSQMessagesAvatarImage!
    var outgoingAvatar: JSQMessagesAvatarImage!
    
    var senderImageUrl: String!
    
    
    var batchMessages = true
    var ref: Firebase!
    
    
    
    func setupFirebase() {
        // *** STEP 2: SETUP FIREBASE
        messagesRef = Firebase(url: "https://limba.firebaseio.com/messages")
        
        self.messagesRef.queryOrderedByChild("thread").queryEqualToValue(SELECTED_THREAD_ID).observeEventType(.ChildAdded, withBlock: { snapshot in
            
            let value : Dictionary <String, AnyObject> = snapshot.value as! Dictionary <String, AnyObject>
            let text = value["text"] as? String
            let sender = value["sender"] as? String
            let imageUrl = value["imageUrl"] as? String
            let senderDisplayName = value["sender"] as? String     //TODO ADD DISPLAY NAME
//            let message = Message(senderId: sender!, senderDisplayName: sender!, isMediaMessage: false, hash: 10, text: text!, imageUrl: imageUrl!)
            
            let message = JSQMessage(senderId: sender, displayName: senderDisplayName, text: text)
//            self.messages.append
            self.messages?.append(message)
//            self.finishReceivingMessage()
            self.finishReceivingMessageAnimated(true)
            
        })
        
//        print("selected:",SELECTED_THREAD_ID)
//        print ("len should be 2:",self.messages.count)
        
        
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
        if CURRENT_USSER_IS_TEACHER{
            self.delegate.transitionToChatThreadPage()
        }
        else {
            self.delegate.returnToDash()
        }
        //performSegueWithIdentifier(SEG_FROM_CHAT, sender: self)
        //self.delegate.exitChat()
    }
    
    //view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        
        let bubbleFactory = JSQMessagesBubbleImageFactory()
        self.incomingBubble = bubbleFactory.incomingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleLightGrayColor())
        self.outgoingBubble = bubbleFactory.outgoingMessagesBubbleImageWithColor(UIColor.jsq_messageBubbleGreenColor())
        
        self.incomingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "profile")!, diameter: 64)
        self.outgoingAvatar = JSQMessagesAvatarImageFactory.avatarImageWithImage(UIImage(named: "profile")!, diameter: 64)
        
        
        self.collectionView.frame = CGRect(x: 0, y: self.view.frame.height * 0.2, width: self.view.frame.width, height: self.view.frame.height * 0.9)
        // Do any additional setup after loading the view, typically from a nib.
//        inputToolbar.contentView.leftBarButtonItem = nil
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
        
        
        self.messages = []
        
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
        return self.messages?[indexPath.item]
    }
    
    
    func collectionView(collectionView: JSQMessagesCollectionView!, bubbleImageViewForItemAtIndexPath indexPath: NSIndexPath!) -> UIImageView! {
        let message = messages?[indexPath.item]
        
        if message!.senderId == sender {
            return UIImageView(image: outgoingBubble.messageBubbleImage, highlightedImage: outgoingBubble.messageBubbleHighlightedImage)
        }
        
        return UIImageView(image: incomingBubble.messageBubbleImage, highlightedImage: incomingBubble.messageBubbleHighlightedImage)
    }
    
    
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingAvatar
        }
        return self.incomingAvatar
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (messages?.count)!
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        
        let message = messages?[indexPath.item]
        if message!.senderId == sender {
            cell.textView.textColor = UIColor.whiteColor()
        } else {
            cell.textView.textColor = UIColor.blackColor()
        }
        
        let attributes : [String:AnyObject] = [NSForegroundColorAttributeName:cell.textView.textColor!, NSUnderlineStyleAttributeName: 1]
        cell.textView.linkTextAttributes = attributes
        
//        let view = UIView(frame: cell.fra)
        
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: cell.contentView.frame.width, height: cell.contentView.frame.height))
        button.setTitle("", forState: .Normal)
        button.addTarget(self, action: #selector(ChatViewController.clickedTask), forControlEvents: .TouchDown)
        cell.contentView.addSubview(button)
        
//        cell.textView.linkTextAttributes = [NSForegroundColorAttributeName: cell.textView.textColor!, NSUnderlineStyleAttributeName: 1]
        return cell
    }
    
    func clickedTask(){
        if CURRENT_USSER_IS_TEACHER {
            self.delegate.showTaskSummary()
        }
        else{
            self.delegate.goToPlayView()
        }
    }
    
    // View  usernames above bubbles
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        let message = messages?[indexPath.item];
        
        // Sent by me, skip
        if message!.senderId == sender {
            return nil;
        }
        
        // Same as previous sender, skip
        if indexPath.item > 0 {
            let previousMessage = messages?[indexPath.item - 1];
            if previousMessage!.senderId == message!.senderId {
                return nil;
            }
        }
        
        return NSAttributedString(string:message!.senderId)
    }

    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.messages?[indexPath.item]
        if message?.senderId == self.senderId {
            return self.outgoingBubble
        }
        return self.incomingBubble
        
        
    }
    
    //accessory part
    override func didPressAccessoryButton(sender: UIButton!) {
        showAlert()
    }
    
    
    func showAlert(){
        
        let alert = UIAlertController(title: "Limba",message: nil, preferredStyle: .ActionSheet)
        
        let firstAction = UIAlertAction(title: "Send Task", style: .Default){
            action in
            
            //TODOTODOTODOTODOTODOTO            
            DID_COME_FROM_CHAT = true;
            self.delegate.goToTaskCreation()
            
            
        }
        let secondAction = UIAlertAction(title: "Send Photo", style: .Default){
            action in
            self.presentPickerController(.PhotoLibrary)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default,handler : nil)
        
        
        alert.addAction(firstAction)
        alert.addAction(secondAction)
        alert.addAction(cancelAction)
        
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func closeTask(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func presentTask(){
        
    }
    
    func sendTaskMessage(){
        self.sendMessage("teacher1 sent a task. Click here to complete!", sender: "teacher1", msg_date: NSDate())
    }
    
    func sendTaskCompMessage(){
        self.sendMessage("Katie H completed a task. Click here to view!", sender: CURRENT_USER_ID, msg_date: NSDate())
    }
    
    
    func presentPickerController(sourceType:UIImagePickerControllerSourceType){
        if UIImagePickerController.isSourceTypeAvailable(sourceType){
            let picker = UIImagePickerController()
            picker.sourceType = sourceType
//            picker.delegate = self
            self.presentViewController(picker, animated:true, completion:nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: NSDictionary!) {
        self.dismissViewControllerAnimated(true, completion: nil)
        
        //写真をJSQPhotoMediaItemの型で配列に追加
        let photoItem = JSQPhotoMediaItem(image: image)
        photoItems?.append(photoItem)
        //新しいメッセージデータを追加する
        let message = JSQMessage(senderId: senderId, displayName: senderDisplayName, media: photoItems![photoItems!.count-1])
        
//        sendMessage(message)
    }
    
    //END JSQ MESSAGE COLLECTION VIEW SECTION ------------------------------------------------------------------------
    
    
    func dateToString(date : NSDate) -> String{
         return dateFormatter.stringFromDate(date)
    }
    
    
}