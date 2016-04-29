//
//  TopBar.swift
//  448Piano
//
//  Created by William Bertrand on 4/21/16.
//  Copyright © 2016 William. All rights reserved.
//

import Foundation
import UIKit

protocol TopBarDelegate {
    func showMenu()
}

class TopBar : UIView {

    var delegate: TopBarDelegate?
    var searchButton : UIButton!
    var searchBar : UIView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    required override init(frame: CGRect) {
        super.init(frame: frame)
        
        let menuDim = frame.width * 0.08
        //Add profile button
        let menuButton = UIButton(frame: CGRect(x: frame.width * 0.05, y: (frame.height * 0.5 - frame.height * 0.025), width: menuDim, height: frame.height * 0.5))
        menuButton.setImage(UIImage(named: "menuIcon"), forState: UIControlState.Normal)
        menuButton.imageView?.contentMode = .ScaleAspectFit
        //add target TODO
        menuButton.addTarget(self, action: #selector(TopBar.slideOutMenuView), forControlEvents: .TouchUpInside)
        addSubview(menuButton)
        //add search button
        let searchButton = UIButton(frame: CGRect(x: frame.width * 0.9, y: (frame.height * 0.5 - frame.height * 0.025), width: frame.width * 0.05, height: frame.width * 0.05))
        searchButton.setImage(UIImage(named: "searchIcon"), forState: UIControlState.Normal)
        searchButton.imageView?.contentMode = .ScaleAspectFit
        //add target
        
        backgroundColor = UIColor.whiteColor()
//        searchButton.addTarget(self, action: #selector(TopBar.initiateSearch), forControlEvents: .TouchUpInside)
        addSubview(searchButton)
        
//        searchBar = UIView(frame: CGRect(x: frame.width, y:(frame.height * 0.5 - frame.height * 0.025), width: 10, height: frame.width * 0.05))
//        searchBar.layer.cornerRadius = 3;
//        searchBar.backgroundColor = LINE_COLOR_RB2;
//        self.addSubview(searchBar)
//        
        
        
    }
    
//    func initiateSearch() {
//        UIView.animateWithDuration(0.75) {
//            self.searchButton.frame = CGRect(x: self.frame.width * 0.2, y: (self.frame.height * 0.5 - self.frame.height * 0.025), width: self.frame.width * 0.05, height: self.frame.width * 0.05)
//            self.searchBar.frame = CGRect(x: self.frame.width * 0.25, y:(self.frame.height * 0.5 - self.frame.height * 0.025), width: self.frame.width, height: self.frame.width * 0.05)
//        }
//        
//    }
//    
//    func closeSearch() {
//        UIView.animateWithDuration(0.75) {
//            self.searchButton.frame = CGRect(x: self.frame.width * 0.2, y: (self.frame.height * 0.5 - self.frame.height * 0.025), width: self.frame.width * 0.05, height: self.frame.width * 0.05)
//        }
//    }
//    
    
    func slideOutMenuView(){
        print("menu pressed, sliding")
        delegate?.showMenu()
        
    }

    
}

