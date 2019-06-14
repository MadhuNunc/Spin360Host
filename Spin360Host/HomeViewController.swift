//
//  HomeViewController.swift
//  360Video
//
//  Created by apple on 5/21/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import CSSpin
import MagicalRecord

class HomeViewController: UIViewController, CSCaptureViewControllerDelegate, Spin360ListViewControllerDelegate, ProcessAndUploadViewControllerDelegate {
    var capture360Button : UIButton!
    var processingButton : UIButton!
    var preview360Button : UIButton!
    var upload360Button : UIButton!
    var pano360Button : UIButton!
    var previewPanoButton : UIButton!
    var uploadPanoButton : UIButton!
    var loggingButton : UIButton!

    var selSpin360Object: Spin360List!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.portraitOrientation()
        
        self.designUI()
        
        // Do any additional setup after loading the view.
    }
    
    /**
     Designed to display all categories on home screen
    */
    func designUI () {
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
        
        self.capture360Button = self.createButton(title: Constants.CAPTURE_360, frame: CGRect(x: 20, y: 40 , width: screenWidth-40, height: buttonHeight))
        self.capture360Button.addTarget(self, action:#selector(self.tappedCaptureButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.capture360Button)
        
        self.processingButton = self.createButton(title: Constants.PROCESS_360, frame: CGRect(x: self.capture360Button.frame.origin.x, y: self.capture360Button.frame.origin.y+self.capture360Button.frame.size.height+20, width: self.capture360Button.frame.size.width, height: self.capture360Button.frame.size.height))
        self.processingButton.addTarget(self, action:#selector(self.tappedProcessButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.processingButton)
        
        self.preview360Button = self.createButton(title: Constants.PREVIEW_360, frame: CGRect(x: self.capture360Button.frame.origin.x, y: self.processingButton.frame.origin.y+self.processingButton.frame.size.height+20, width: self.capture360Button.frame.size.width, height: self.capture360Button.frame.size.height))
        self.preview360Button.addTarget(self, action:#selector(self.tappedPreviewButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.preview360Button)
        
        self.upload360Button = self.createButton(title: Constants.UPLOAD_360, frame: CGRect(x: self.capture360Button.frame.origin.x, y: self.preview360Button.frame.origin.y+self.preview360Button.frame.size.height+20, width: self.capture360Button.frame.size.width, height: self.capture360Button.frame.size.height))
        self.upload360Button.addTarget(self, action:#selector(self.tappeduploadButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.upload360Button)
        
        self.pano360Button = self.createButton(title: Constants.PANO, frame: CGRect(x: self.capture360Button.frame.origin.x, y: self.upload360Button.frame.origin.y+self.upload360Button.frame.size.height+20, width: self.capture360Button.frame.size.width, height: self.capture360Button.frame.size.height))
        self.pano360Button.addTarget(self, action:#selector(self.tappedPanoButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.pano360Button)
        
        self.preview360Button = self.createButton(title: Constants.PREVIEW_PANO, frame: CGRect(x: self.capture360Button.frame.origin.x, y: self.pano360Button.frame.origin.y+self.pano360Button.frame.size.height+20, width: self.capture360Button.frame.size.width, height: self.capture360Button.frame.size.height))
        self.preview360Button.addTarget(self, action:#selector(self.tappedPreviewPanoButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.preview360Button)
        
        self.uploadPanoButton = self.createButton(title: Constants.UPLOAD_PANO, frame: CGRect(x: self.capture360Button.frame.origin.x, y: self.preview360Button.frame.origin.y+self.preview360Button.frame.size.height+20, width: self.capture360Button.frame.size.width, height: self.capture360Button.frame.size.height))
        self.uploadPanoButton.addTarget(self, action:#selector(self.tappedUploadPanoButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.uploadPanoButton)
        
        self.loggingButton = self.createButton(title: Constants.LOGGING, frame: CGRect(x: self.capture360Button.frame.origin.x, y: self.uploadPanoButton.frame.origin.y+self.uploadPanoButton.frame.size.height+20, width: self.capture360Button.frame.size.width, height: self.capture360Button.frame.size.height))
        self.loggingButton.addTarget(self, action:#selector(self.tappedLoggingButton(_:)), for: UIControl.Event.touchUpInside)
        scrollView.addSubview(self.loggingButton)
    }
    
    /**
     Createbutton method allows to create buttons multiple times without rewriting the same code
    */
    func createButton (title: String, frame: CGRect) -> UIButton {
        let backgroudColor : UIColor = UIColor.white
        let textColor : UIColor = UIColor.black
        
        let button:UIButton = UIButton(frame: frame)
        button.setTitle(title, for: UIControl.State.normal)
        button.backgroundColor = backgroudColor
        button.setTitleColor(textColor, for: UIControl.State.normal)
        return button;
    }
    
    /**
     Portrait orientation method allows screen to load in Portrait mode
    */
    func portraitOrientation () {
        let orientValue = NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue)
        UIDevice.current.setValue(orientValue, forKey: "orientation")
        
        print("Orientation value is \(orientValue)")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.restrictRotation = false;
    }
    
    /**
     Landscape orientation method allows screen to load in Landscape mode
     */
    func landScapeOrientation () {
        let orientValue = NSNumber(integerLiteral: Int(UIInterfaceOrientationMask.landscape.rawValue))
        UIDevice.current.setValue(orientValue, forKey: "orientation")
        
        print("Orientation value is \(orientValue)")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.restrictRotation = true;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.portraitOrientation()
    }
    
    /**
     showAlert method allows to display necessary alert messages for that action
    */
    @objc func showAlert(alert: String, title: String) {
        let alertController = UIAlertController(title: title, message: alert, preferredStyle: .alert)
        
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: nil)
    }
    
    /**
     callCaptureVC method allows to perform below declared functionalities.
     - Capture 360
     - Process 360
     - Preview 360
     - Upload 360
     - Capture Pano
     - Pano Preview
     - Pano Upload
    */
    func callCaptureVC(captureState: NSInteger, title: String) {
        if captureState == CAPTURE_STATE.CAPTURE_360_STATE.rawValue || captureState == CAPTURE_STATE.PREVIEW_STATE.rawValue || captureState == CAPTURE_STATE.PANO_STATE.rawValue || captureState == CAPTURE_STATE.PANO_PREVIEW_STATE.rawValue {
            self.landScapeOrientation()
            
            let vc:CSCaptureViewController = CSCaptureViewController.init(nibName: nil, bundle: nil)
            vc.delegate = self
            vc.captureState = captureState;
            vc.title = title
            let navcon:UINavigationController = UINavigationController.init(rootViewController: vc)
            self.present(navcon, animated: true, completion: {
            })
            
        } else {
            self.portraitOrientation()
            
            let vc:ProcessAndUploadViewController = ProcessAndUploadViewController.init(nibName: nil, bundle: nil)
            vc.title = title
            vc.delegate = self
            vc.captureState = captureState
            vc.selSpin360Object = selSpin360Object
            let navcon:UINavigationController = UINavigationController.init(rootViewController: vc)
            self.present(navcon, animated: true, completion: {
            })
        }
    }
    
    @objc func tappedCaptureButton(_ sender:UIButton){
        self.callCaptureVC(captureState: CAPTURE_STATE.CAPTURE_360_STATE.rawValue, title: Constants.CAPTURE_VIEW_CONTROLLER)
    }
    
    @objc func tappedLoggingButton(_ sender:UIButton){
        let vc:LoggingViewController = LoggingViewController.init(nibName: nil, bundle: nil)
        vc.title = "Logging"
        let navcon:UINavigationController = UINavigationController.init(rootViewController: vc)
        self.present(navcon, animated: true, completion: {
        })
    }
    
    /**
    callListVC method allows to display 360 Capture and Pano list screens
    */
    func callListVC(captureState: NSInteger, title: String, listType: String) {
        let vc:Spin360ListViewController = Spin360ListViewController.init(nibName: nil, bundle: nil)
        vc.title = title
        vc.delegate = self
        vc.captureState = captureState
        vc.listType = listType
        let navcon:UINavigationController = UINavigationController.init(rootViewController: vc)
        self.present(navcon, animated: true, completion: {
            
        })
    }
    
    @objc func tappedProcessButton(_ sender:UIButton){
        self.callListVC(captureState: CAPTURE_STATE.PROCESS_STATE.rawValue, title: Constants.SPIN_360_LIST, listType: Constants.PROCESS_360)
    }
    
    /**
    didSelectAction method allows required screens to perform based on functionalities
    */
    func didSelectAction(_ sender:Spin360ListViewController, captureState: NSInteger, capturedObject: Spin360List) {
        self.selSpin360Object = capturedObject
        
        var mesage : String!
        if captureState == CAPTURE_STATE.PROCESS_STATE.rawValue {
            mesage = Constants.PROCESS_VIEW_CONTROLLER
        } else if captureState == CAPTURE_STATE.PREVIEW_STATE.rawValue {
            mesage = Constants.PRIVIEW_VIEW_CONTROLLER
        } else if captureState == CAPTURE_STATE.UPLOAD_STATE.rawValue {
            mesage = Constants.UPLOAD_VIEW_CONTROLLER
        } else if (captureState == CAPTURE_STATE.PANO_PREVIEW_STATE.rawValue) {
            mesage = Constants.PANO_PREVIEW_VIEW_CONTROLLER
        } else if (captureState == CAPTURE_STATE.PANO_UPLOAD_STATE.rawValue) {
            mesage = Constants.PANO_UPLOAD_CONTROLLER
        }
        self.callCaptureVC(captureState: captureState, title: mesage)
    }
    
    @objc func tappedPreviewButton(_ sender:UIButton){
        self.callListVC(captureState: CAPTURE_STATE.PREVIEW_STATE.rawValue, title: Constants.SPIN_360_LIST, listType: Constants.PREVIEW_360)
    }
    
    @objc func tappeduploadButton(_ sender:UIButton){
        self.callListVC(captureState: CAPTURE_STATE.UPLOAD_STATE.rawValue, title: Constants.SPIN_360_LIST, listType: Constants.UPLOAD_360)
    }
    
    @objc func tappedPanoButton(_ sender:UIButton){
        self.callCaptureVC(captureState: CAPTURE_STATE.PANO_STATE.rawValue, title: Constants.PANO_VIEW_CONTROLLER)
    }
    
    @objc func tappedPreviewPanoButton(_ sender:UIButton){
        self.callListVC(captureState: CAPTURE_STATE.PANO_PREVIEW_STATE.rawValue, title: Constants.PANO_LIST, listType: Constants.PREVIEW_PANO)
    }
    
    @objc func tappedUploadPanoButton(_ sender:UIButton){
        self.callListVC(captureState: CAPTURE_STATE.PANO_UPLOAD_STATE.rawValue, title: Constants.PANO_LIST, listType: Constants.UPLOAD_PANO)
    }
    
    /**
     saveRecordInDB method allows the capture 360 and pano records saving to Database
    */
    func saveRecordInDB (message: String) {
        if (message == Constants.CAPTURING_COMPLETED || message == Constants.PANO_COMPLETED) {
            let uuid = NSUUID().uuidString
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let locale = NSLocale(localeIdentifier: "en_US_POSIX")
            formatter.locale = locale as Locale
            let result = formatter.string(from: date)
            
            let spin360Object : Spin360List! = Spin360List.mr_createEntity()
            spin360Object.videoName = uuid
            spin360Object.videoGUID = uuid
            spin360Object.timeStamp = result
            spin360Object.uploadStatus = Constants.PENDING
            spin360Object.processStatus = Constants.PENDING
            spin360Object.dateForSorting = date
            if (message == Constants.CAPTURING_COMPLETED) {
                spin360Object.videoType = Constants.SPIN_360
            } else {
                spin360Object.videoType = Constants.PANO
            }
        }
        
        if (message == Constants.PROCESSING_COMPLETED ) {
            selSpin360Object.processStatus = Constants.COMPLETED
        } else if (message == Constants.UPLOADING_COMPLETED) {
            selSpin360Object.uploadStatus = Constants.COMPLETED
        } else if (message == Constants.PANO_UPLOADING_COMPLETED) {
            selSpin360Object.uploadStatus = Constants.COMPLETED
        }
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    /**
     spinCompleteAction allows to save record in database and displays alert messages
    */
    @objc func spinCompleteAction(_ message: String ) {
        print("Stop Button Tapped")
        self.saveRecordInDB(message: message)
        
        let isEqual = (message == Constants.PANO_COMPLETED || message == Constants.PANO_PREVIEW_COMPLETED || message == Constants.PANO_UPLOADING_COMPLETED)
        if isEqual {
            showAlert(alert: message, title: Constants.PANO)
        } else {
            showAlert(alert: message, title: Constants.SPIN_360)
        }
    }
    
    /**
     spinCancelAction allows to stops current action and displays alert messages
    */
    @objc func spinCancelAction(_ message : String ){
        print("Cancel Button Tapped")
        
        let isEqual = (message == Constants.PANO_CANCELLED || message == Constants.PANO_PREVIEW_CLOSED || message == Constants.PANO_UPLOAD_CANCELLED)
        if isEqual {
            showAlert(alert: message, title: Constants.PANO)
        } else {
            showAlert(alert: message, title: Constants.SPIN_360)
        }
    }
}

