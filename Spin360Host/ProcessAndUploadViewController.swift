//
//  ProcessAndUploadViewController.swift
//  Capture360Demo
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import CSSpin
import MagicalRecord

protocol ProcessAndUploadViewControllerDelegate {
    func showAlert(alert: String, title: String)
}

class ProcessAndUploadViewController: UIViewController, CSModuleSyncDelegate {
    var delegate:ProcessAndUploadViewControllerDelegate?

    var captureState: NSInteger!
    
    var processButton : UIButton!
    var cancelButton : UIButton!
    var processLabel : UILabel!
    var progressView : UIProgressView!
    var selSpin360Object: Spin360List!
    var processing : Bool! = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.designUI()
        // Do any additional setup after loading the view.
    }
    
    func designUI () {
        let controlsView=UIView(frame: CGRect(x: (self.view.frame.width-150)/2, y: self.view.frame.height-100, width: 130, height: 50))
        self.view.addSubview(controlsView)
        
        self.cancelButton = self.createButton(title: "", frame: CGRect(x: 0, y: 0 , width: 50, height: 50))
        self.cancelButton.addTarget(self, action:#selector(self.tappedCancelButton(_:)), for: UIControl.Event.touchUpInside)
        self.cancelButton .setImage(UIImage.init(named: "cancel_icon"), for: UIControl.State.normal)
        controlsView.addSubview(self.cancelButton)
        
        self.processButton = self.createButton(title: "", frame: CGRect(x: cancelButton.frame.origin.x+cancelButton.frame.size.width+30, y: 0 , width: 50, height: 50))
        self.processButton.addTarget(self, action:#selector(self.tappedProcessButton(_:)), for: UIControl.Event.touchUpInside)
        
        if (captureState == CAPTURE_STATE.PROCESS_STATE.rawValue) {
            self.processButton .setImage(UIImage.init(named: "process_icon"), for: UIControl.State.normal)
        } else {
            self.processButton .setImage(UIImage.init(named: "upload_icon"), for: UIControl.State.normal)
        }
        controlsView.addSubview(self.processButton)
        
        self.processLabel = UILabel(frame: CGRect(x: (self.view.frame.width-200)/2, y: (self.view.frame.height-30)/2, width: 200, height: 30))
        self.processLabel.textAlignment = .center
        self.processLabel.textColor = .white
        self.view.addSubview(self.processLabel)
        
        self.progressView = UIProgressView(progressViewStyle: .bar)
        self.progressView.layer.frame = CGRect (x: (self.view.frame.width-150)/2, y: (self.view.frame.height-100)/2, width: 150, height: 30)
        self.progressView.setProgress(0.0, animated: true)
        self.progressView.trackTintColor = .white
        self.progressView.tintColor = .gray
        view.addSubview(self.progressView)
        self.progressView.isHidden = true
    }
    
    @objc func tappedCancelButton(_ sender:UIButton) {
        CSModuleSync.sharedService().stopProgress()
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc func tappedProcessButton(_ sender:UIButton) {
        self.processButton .setImage(UIImage.init(named: "stop_icon"), for: UIControl.State.normal)

        if (!self.processing) {
            self.processing = true;
            CSModuleSync.sharedService().startProgressAndObject(self, andCaptureState: captureState)
        } else {
            CSModuleSync.sharedService().stopProgress()
            self.dismiss(animated: true) {
                //self.updateRecordInDB()
                if (self.captureState == CAPTURE_STATE.PANO_UPLOAD_STATE.rawValue) {
                    self.delegate?.showAlert(alert: Constants.UPLOAD_CANCELLED, title: Constants.PANO)
                } else if (self.captureState == CAPTURE_STATE.UPLOAD_STATE.rawValue){
                    self.delegate?.showAlert(alert: Constants.UPLOAD_CANCELLED, title: Constants.SPIN_360)
                } else {
                    self.delegate?.showAlert(alert: Constants.PROCESS_CANCELLED , title: Constants.SPIN_360)
                }
            }
        }
    }
    
    func createButton (title: String, frame: CGRect) -> UIButton {
        let button:UIButton = UIButton(frame: frame)
        return button;
    }
    
    func uploadProgress(_ progress: Float, andCaptureState captureState: Int) {
        print("Upload Progress: \(progress)")
        
        self.progressView.isHidden = false

        UIView.animate(withDuration: 3, animations: { () -> Void in
            self.progressView.setProgress(progress, animated: true)
        })

        let progress: NSInteger = NSInteger(progress*100)

        if (captureState == CAPTURE_STATE.UPLOAD_STATE.rawValue) {
            self.processLabel.text = "Uploading 360...(\(progress)%)"
        } else if (captureState == CAPTURE_STATE.PANO_UPLOAD_STATE.rawValue) {
            self.processLabel.text = "Uploading Pano...(\(progress)%)"
        }
        
        if (progress == 100) {
            self.dismiss(animated: true) {
                self.updateRecordInDB()
                if (captureState == CAPTURE_STATE.PANO_UPLOAD_STATE.rawValue) {
                    self.delegate?.showAlert(alert: Constants.PANO_UPLOADING_COMPLETED , title: Constants.PANO)
                } else {
                    self.delegate?.showAlert(alert: Constants.UPLOADING_COMPLETED , title: Constants.SPIN_360)
                }
            }
        }
        
        
    }
    
    func updateProgress(_ remainingTime: Int32, andCaptureState captureState: Int) {
        self.processLabel.text = "Processing 360...(\(remainingTime))"
        
        if (remainingTime == 0) {
            self.dismiss(animated: true) {
                self.updateRecordInDB()
                self.delegate?.showAlert(alert: Constants.PROCESSING_COMPLETED , title: Constants.SPIN_360)
            }
        }
    }
    
    func updateRecordInDB () {
        if (captureState == CAPTURE_STATE.PROCESS_STATE.rawValue ) {
            selSpin360Object.processStatus = Constants.COMPLETED
        } else if (captureState == CAPTURE_STATE.UPLOAD_STATE.rawValue) {
            selSpin360Object.uploadStatus = Constants.COMPLETED
        } else if (captureState == CAPTURE_STATE.PANO_UPLOAD_STATE.rawValue) {
            selSpin360Object.uploadStatus = Constants.COMPLETED
        }
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
}
