//
//  FFLoggingViewController.swift
//  Capture360Demo
//
//  Created by apple on 6/12/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class FFLoggingViewController: UIViewController {
    var errorButton : UIButton!
    var warnButton : UIButton!
    var infoButton : UIButton!
    var debugButton : UIButton!
    var traceButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       self.designUI()
        // Do any additional setup after loading the view.
    }
    
    func designUI () {
        let button1 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = button1
        
        let barHeight: CGFloat = UIApplication.shared.statusBarFrame.size.height
        
        let buttonHeight : CGFloat = 50
        
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        
        var scrollView: UIScrollView!
        scrollView = UIScrollView(frame: CGRect(x: 0, y:barHeight , width: screenWidth, height: screenHeight-barHeight))
        scrollView.contentSize = CGSize(width: screenWidth, height: 20*8+50*8)
        scrollView.backgroundColor = UIColor.black
        view.addSubview(scrollView)
        
        self.errorButton = self.createButton(title: "Error", frame: CGRect(x: 20, y: 40 , width: screenWidth-40, height: buttonHeight))
        self.errorButton.addTarget(self, action:#selector(self.tappedErrorButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.errorButton)
        
        self.warnButton = self.createButton(title: "Warn", frame: CGRect(x: self.errorButton.frame.origin.x, y: self.errorButton.frame.origin.y+self.errorButton.frame.size.height+20, width: self.errorButton.frame.size.width, height: self.errorButton.frame.size.height))
        self.warnButton.addTarget(self, action:#selector(self.tappedWarnButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.warnButton)
        
        self.infoButton = self.createButton(title: "Info", frame: CGRect(x: self.errorButton.frame.origin.x, y: self.warnButton.frame.origin.y+self.warnButton.frame.size.height+20, width: self.errorButton.frame.size.width, height: self.errorButton.frame.size.height))
        self.infoButton.addTarget(self, action:#selector(self.tappedInfoButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.infoButton)
        
        self.debugButton = self.createButton(title: "Debug", frame: CGRect(x: self.errorButton.frame.origin.x, y: self.infoButton.frame.origin.y+self.infoButton.frame.size.height+20, width: self.errorButton.frame.size.width, height: self.errorButton.frame.size.height))
        self.debugButton.addTarget(self, action:#selector(self.tappedDebugButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.debugButton)
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func callLoggingDetails (title: String, logType: NSInteger) {
        let vc:FFLoggingDetailsViewController = FFLoggingDetailsViewController.init(nibName: nil, bundle: nil)
        vc.title = title
        vc.logType = logType
        let navcon:UINavigationController = UINavigationController.init(rootViewController: vc)
        self.present(navcon, animated: true, completion: {
        })
    }
    
    @objc func tappedErrorButton(_ sender:UIButton){
        self.callLoggingDetails(title: Constants.LOG_ERROR, logType: LOG_TYPE.LOG_ERROR.rawValue)
    }
    
    @objc func tappedWarnButton(_ sender:UIButton){
        self.callLoggingDetails(title: Constants.LOG_WARN, logType:  LOG_TYPE.LOG_WARN.rawValue)
    }
    
    @objc func tappedInfoButton(_ sender:UIButton){
        self.callLoggingDetails(title: Constants.LOG_INFO, logType:  LOG_TYPE.LOG_INFO.rawValue)
    }
    
    @objc func tappedDebugButton(_ sender:UIButton){
        self.callLoggingDetails(title: Constants.LOG_DEBUG, logType:  LOG_TYPE.LOG_DEBUG.rawValue)
    }
    
    func createButton (title: String, frame: CGRect) -> UIButton {
        let backgroudColor : UIColor = UIColor.white
        let textColor : UIColor = UIColor.black
        
        let button:UIButton = UIButton(frame: frame)
        button.setTitle(title, for: UIControl.State.normal)
        button.backgroundColor = backgroudColor
        button.setTitleColor(textColor, for: UIControl.State.normal)
        return button;
    }
}
