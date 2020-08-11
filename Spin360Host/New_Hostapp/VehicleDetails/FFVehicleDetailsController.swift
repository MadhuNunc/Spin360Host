//
//  FFVehicleDetailsController.swift
//  Spin360Host
//
//  Created by apple on 5/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MSCircularProgressView
import FFSpinSDK

let spinProcessDidFinish = Notification.Name(rawValue: "spinProcessDidFinish")
let spinProcessDidFail = Notification.Name(rawValue: "spinProcessDidFailed")
let spinProcessDidUpdateProgress = Notification.Name(rawValue: "spinProcessDidUpdateProgress")
let getPhotosUpdateNotify = Notification.Name(rawValue: "getPhotosUpdateNotify")
let getPhotosFailedNotify = Notification.Name(rawValue: "getPhotosFailedNotify")
let getPhotosDidUpdateProgress = Notification.Name(rawValue: "getPhotosDidUpdateProgress")

class FFVehicleDetailsController: UIViewController {
    var vehicelObject:FFVehicleList!
    weak var collectionView: UICollectionView!
    var data:Array = [Constants.EXTERIOR_360_TITLE, Constants.INTERIOR_360_TITLE]
    var vehicleSegmentedControl:UISegmentedControl!
    
    // Photos UI
    var getPhotosButton: UIButton!
    private var photosList:NSMutableArray!

    var noPhotosLabel:UILabel!
    
    var collectionViewHeight:CGFloat = 0
    var yPosition:CGFloat = 0
    
    var progressLabel: UILabel!
    var progressBar: MSProgressView!

    private func initializeProcessNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleSpinProcessSuccessful(notification:)), name: spinProcessDidFinish, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSpinProcessFailed(notification:)), name: spinProcessDidFail, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleSpinProcessProgress(notification:)), name: spinProcessDidUpdateProgress, object: nil)
    }
    
    func updatePhotosUI (captureId: String) {
        if FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId).count > 0 {
            let vehicleObject:FFVehicleList = FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId)[0] as! FFVehicleList
            
            self.photosList = FFHelper.app.convertIntoJSONArray(string: vehicleObject.photos ?? "")
            
            print("Photos Array: \(self.photosList ?? []))")
                        
            if self.vehicleSegmentedControl.selectedSegmentIndex == 0 {
                if self.photosList.count > 0 {
                    self.noPhotosLabel.isHidden = true
                    self.collectionView.reloadData()
                } else {
                    self.noPhotosLabel.isHidden = false
                    self.noPhotosLabel.text = "No Photos detected"
                }
                
                self.showPhotosProgress()
            }
        }
    }
    
    @objc private func handleGetPhotosUpdate(notification: Notification) {
        DispatchQueue.main.async {
            print("Photos List: \(String(describing: notification.userInfo))")
            if (self.vehicelObject.spinId == notification.userInfo?["captureId"] as? String) {
                self.updatePhotosUI(captureId: (notification.userInfo?["captureId"])! as! String)
            }
        }
    }
    
    @objc private func handleGetPhotosFailed(notification: Notification) {
        DispatchQueue.main.async {
            print("Get Photos Failed Response: \(String(describing: notification.userInfo))")
            
            if (self.vehicelObject.spinId == notification.userInfo?["captureId"] as? String) {
                if self.vehicleSegmentedControl.selectedSegmentIndex == 0 {
                    self.noPhotosLabel.isHidden = false
                    self.noPhotosLabel.text = notification.userInfo?["description"] as? String
                }
            }
            
        }
    }
    
    @objc private func handleGetPhotosProgress(notification: Notification) {
        DispatchQueue.main.async {
            print("Get Photos Progress Response: \(String(describing: notification.userInfo))")
            
            if (self.vehicelObject.spinId == notification.userInfo?["captureId"] as? String) {
                
                if self.vehicleSegmentedControl.selectedSegmentIndex == 0 {
                    self.showPhotosProgress()
                }
            }
            
        }
    }
    
    
    func showPhotosProgress () {
        DispatchQueue.main.async {
            let progressStatus  = FFProcessingManager.shared().getPhotosStatusforCaptureId(self.vehicelObject.spinId!)
            
            print("Photos Progress Status: \(progressStatus)")

            if progressStatus == GET_PHOTOS_STATUS.GET_PHOTOS_PENDING.rawValue || progressStatus == GET_PHOTOS_STATUS.GET_PHOTOS_FAILED.rawValue {
                self.progressLabel.isHidden = true
                self.progressBar.isHidden = true
               
            }
            else if progressStatus == GET_PHOTOS_STATUS.GET_PHOTOS_IN_PROGRESS.rawValue {
                self.progressLabel.isHidden = false
                self.progressBar.isHidden = false
                let progressValue  = FFProcessingManager.shared().getPhotosProgressValueforCaptureId(self.vehicelObject.spinId!)
                let progressval = progressValue*100
                let progress = String(format: "%.0f%@", progressval,"%")
                
                print("Photos Progress: \(progress)")
                
                self.progressLabel.text = progress as String
                self.progressBar.setProgress(Double(progressValue))
                
                if progressval == 100 {
                    self.progressLabel.isHidden = true
                    self.progressBar.isHidden = true
                }
            } else {
                self.progressLabel.isHidden = true
                self.progressBar.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
               
        initializeProcessNotifications()

        NotificationCenter.default.addObserver(self, selector: #selector(handleGetPhotosUpdate(notification:)), name: getPhotosUpdateNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGetPhotosFailed(notification:)), name: getPhotosFailedNotify, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleGetPhotosProgress(notification:)), name: getPhotosDidUpdateProgress, object: nil)

        
        self.view.backgroundColor = .black

        self.title = vehicelObject.vehicleName
        let backButton = FFHelper.app.createButton(imageName: "back", frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        backButton.addTarget(self, action: #selector(backButtonTapped), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem  = barButton

        // Initialize
        vehicleSegmentedControl = UISegmentedControl (items: [Constants.PHOTOS_TITLE,Constants.SPIN_360_TITLE])
        vehicleSegmentedControl.frame = CGRect(x: 10, y: 100, width: self.view.bounds.width-20, height: 40)
        vehicleSegmentedControl.selectedSegmentIndex = 1
        vehicleSegmentedControl.tintColor = UIColor.white
        vehicleSegmentedControl.backgroundColor = UIColor.black
        vehicleSegmentedControl.addTarget(self, action: #selector(segmentedValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(vehicleSegmentedControl)
        
        if #available(iOS 13.0, *) {
            vehicleSegmentedControl.layer.borderColor = UIColor.white.cgColor
            vehicleSegmentedControl.selectedSegmentTintColor = UIColor.white
            vehicleSegmentedControl.layer.borderWidth = 1

            let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            vehicleSegmentedControl.setTitleTextAttributes(titleTextAttributes, for:.normal)

            let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.black]
            vehicleSegmentedControl.setTitleTextAttributes(titleTextAttributes1, for:.selected)
        } else {
            
        }
        
        self.noPhotosLabel = FFHelper.app.createLabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100), fontSize: 18)
        self.noPhotosLabel.center = self.view.center
        self.view.addSubview(self.noPhotosLabel)
        self.noPhotosLabel.isHidden = true
        self.noPhotosLabel.textAlignment = .center
        self.segmentedValueChanged(vehicleSegmentedControl)
        
         // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        FFHelper.app.portraitOrientation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    @objc func backButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func segmentedValueChanged(_ sender:UISegmentedControl!)
    {
        self.noPhotosLabel.isHidden = true

        if self.getPhotosButton != nil {
            self.getPhotosButton.removeFromSuperview()
            self.getPhotosButton = nil
        }
        
        if self.collectionView != nil {
            self.collectionView.removeFromSuperview()
            self.collectionView = nil
        }
        
        if self.progressLabel != nil {
            self.progressLabel.removeFromSuperview()
            self.progressLabel = nil
        }
        
        if self.progressBar != nil {
            self.progressBar.removeFromSuperview()
            self.progressBar = nil
        }
        
        print("Selected Segment Index is : \(sender.selectedSegmentIndex)")
        if sender.selectedSegmentIndex == 0 {
            self.designPhotosUI()
            self.collectionView.isScrollEnabled = true

            guard (self.vehicelObject.spinId != nil && self.vehicelObject.spinId != "") else {
                self.getPhotosButton.alpha = 0.3
                self.getPhotosButton.isUserInteractionEnabled = false
                return
            }
            
            self.getPhotosButton.alpha = 1.0
            self.getPhotosButton.isUserInteractionEnabled = true
            
            self.updatePhotosUI(captureId: self.vehicelObject.spinId!)

        } else {
            self.designSpin360UI()
            self.collectionView.isScrollEnabled = false
        }
    }
    
    func designPhotosUI() {
        getPhotosButton = FFHelper.app.createButton(imageName: "", frame: CGRect(x: self.view.bounds.width-140, y: vehicleSegmentedControl.frame.origin.y+vehicleSegmentedControl.frame.size.height+10, width: 120, height: 40))
        getPhotosButton.setTitle("Get Photos", for: UIControl.State.normal)
        getPhotosButton.backgroundColor = UIColor.white
        getPhotosButton.layer.cornerRadius = 5.0
        getPhotosButton.addTarget(self, action: #selector(getPhotosButtonAction(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(getPhotosButton)
        
        progressLabel = FFHelper.app.createLabel(frame: CGRect(x: getPhotosButton.frame.origin.x-60, y: getPhotosButton.frame.origin.y, width: 40, height: 40), fontSize: 14.0)
        progressLabel.textAlignment = NSTextAlignment.center
        progressLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .medium)
        progressLabel.isHidden = true
        
        progressBar = MSProgressView(frame: CGRect(x: getPhotosButton.frame.origin.x-60, y: getPhotosButton.frame.origin.y, width: 40, height: 40))
        progressBar.setProgress(0.0)
        progressBar.barColor = .green
        progressBar.barWidth = 3.0
        progressBar.isHidden = true
        
        self.view.addSubview(self.progressBar)
        self.view.addSubview(self.progressLabel)
        
        self.designCollectionView(selectedIndex: vehicleSegmentedControl.selectedSegmentIndex)
    }
 
    func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    @objc func getPhotosButtonAction(_ sender: UIButton) {
        
        FFSpinProcessController.sharedInstance.getPhotos(vehicleObject: self.vehicelObject)
        self.showPhotosProgress()

    }
    
    /// Get distance from top, based on status bar and navigation
    public var topDistance : CGFloat{
         get{
             if self.navigationController != nil && !self.navigationController!.navigationBar.isTranslucent{
                 return 0
             }else{
                let barHeight=self.navigationController?.navigationBar.frame.height ?? 0
                let statusBarHeight = UIApplication.shared.isStatusBarHidden ? CGFloat(0) : UIApplication.shared.statusBarFrame.height
                return barHeight + statusBarHeight
             }
         }
    }
    
    func designCollectionView(selectedIndex:Int) {
        if selectedIndex == 0 {
            collectionViewHeight = self.view.bounds.height-(110+self.topDistance)
            yPosition = getPhotosButton.frame.origin.y+getPhotosButton.frame.size.height+10
        } else {
            collectionViewHeight = 410
            yPosition = vehicleSegmentedControl.frame.origin.y+vehicleSegmentedControl.frame.size.height+10
        }
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: yPosition, width: self.view.bounds.width, height: collectionViewHeight), collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(collectionView)
        
        self.collectionView = collectionView
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(FFSpin360Cell.self, forCellWithReuseIdentifier: FFSpin360Cell.identifier)
        self.collectionView.isScrollEnabled = false
        self.collectionView.alwaysBounceVertical = true
        self.collectionView.backgroundColor = .clear
    }
    
    func designSpin360UI() {
        self.designCollectionView(selectedIndex: vehicleSegmentedControl.selectedSegmentIndex)
    }
    
}

extension FFVehicleDetailsController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        if vehicleSegmentedControl.selectedSegmentIndex == 0 {
            return self.photosList?.count ?? 0
        } else {
            return self.data.count
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FFSpin360Cell.identifier, for: indexPath) as! FFSpin360Cell
        
        print("Index Path Index: \(indexPath.row)")
        
        if vehicleSegmentedControl.selectedSegmentIndex == 0 {
            let imageObject = self.photosList[indexPath.row] as! NSDictionary
            
            if (FFHelper.app.getPhotoFromDocumentDirectory(photoPath: imageObject.value(forKey: "photoPath") as! String)).count > 0 {
                cell.imageView.image = UIImage(contentsOfFile: FFHelper.app.getPhotoFromDocumentDirectory(photoPath: imageObject.value(forKey: "photoPath") as! String))
            }
            

            cell.imageView.contentMode = .scaleToFill
            
            cell.textLabel.text = "  \(imageObject.value(forKey: "photoName") ?? "")"
            cell.textLabel.font = UIFont.systemFont(ofSize: 12)
            cell.deleteBothButton.isHidden = true;
            cell.deleteButton.isHidden = true;
        } else {
            let data = self.data[indexPath.item]
            cell.textLabel.text = String("  \(data)")
            
            cell.placeholderImageView.isHidden = false
            cell.delegate = self
            cell.deleteButton.tag = indexPath.row;
            cell.deleteBothButton.tag = indexPath.row;
            
            if indexPath.row == 0 {
                if vehicelObject.spinId?.count ?? 0 > 0 && vehicelObject.panoId?.count ?? 0 > 0  {
                    cell.deleteBothButton.isHidden = false
                } else {
                    cell.deleteBothButton.isHidden = true
                }
                
                if vehicelObject.spinId?.count ?? 0 > 0 {
                    cell.deleteButton.isHidden = false;
                    
                    func display(image: UIImage?) {
                        cell.placeholderImageView.isHidden = true
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                            cell.imageView.contentMode = .scaleToFill
                            
                            let progressStatus  = FFProcessingManager.shared().getProgressStatusforCaptureId(self.vehicelObject.spinId!)
                            if progressStatus == PROCESS_STATUS.PROCESS_PENDING.rawValue || progressStatus == PROCESS_STATUS.PROCESS_FAILED.rawValue {
                                cell.visualEffectView.isHidden = false
                                cell.reviewLabel.isHidden = false
                                cell.progressLabel.isHidden = true
                                if(progressStatus == PROCESS_STATUS.PROCESS_FAILED.rawValue){
                                    cell.reviewLabel.text = "Processing failed.\n Try again to review."
                                }
                            }
                            else if progressStatus == PROCESS_STATUS.PROCESS_IN_PROGRESS.rawValue {
                                cell.visualEffectView.isHidden = true
                                cell.reviewLabel.isHidden = true
                                cell.progressLabel.isHidden = false
                                cell.progressBar.isHidden = false
                                let progressValue  = FFProcessingManager.shared().getProgressValueforCaptureId(self.vehicelObject.spinId!)
                                let progressval = progressValue*100
                                let progress = String(format: "%.0f%@", progressval,"%")
                                cell.progressLabel.text = progress as String
                                cell.progressBar.setProgress(Double(progressValue))
                            }
                        }
                    }
                    
                    if vehicelObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue {
                        let thumbUrlPath = (FFHelper.app.getDirectoryPath(photoPath: "\(vehicelObject.rooftopID!)/\(vehicelObject.iLotId!)/\(vehicelObject.vin!)") as NSURL)
                        let thumbStringPath: String = thumbUrlPath.absoluteString ?? ""

                        FFSpinManager.sharedService().requestExteriorRemoteThumbnailforFFSpinforiLotID(vehicelObject.iLotId!, vin: vehicelObject.vin!, captureID: vehicelObject.spinId!, thumbFilePath: thumbStringPath, thumbWidth: 400, thumbHeight: 300, successBlock: { (status, message, thumbPath) in
                            print("Exterior Status: \(status), Message: \(message), ThumbPath: \(thumbPath)")
                            
                            DispatchQueue.main.async {
                                cell.imageView.image = UIImage.init(contentsOfFile: thumbPath)
                                cell.imageView.contentMode = .scaleToFill
                            }
                            
                        }) { (status, failureMessage) in
                            print("Exterior Status: \(status), Failure Message\(failureMessage)")
                        }
                    } else {
                        FFSpinManager.requestSpinThumbnailImage(forIdentifier: vehicelObject.spinId!, completion: display(image:))
                    }
                } else {
                    cell.deleteButton.isHidden = true;
                    cell.imageView.image = nil
                    cell.placeholderImageView.image = UIImage.init(named: "exterior_360_icn")
                }
            }
            
            if indexPath.row == 1 {
                cell.visualEffectView.isHidden = true
                cell.reviewLabel.isHidden = true
                cell.progressLabel.isHidden = true
                cell.progressBar.isHidden = true
                
                cell.deleteBothButton.isHidden = true
                
                if vehicelObject.panoId?.count ?? 0 > 0 {
                    cell.deleteButton.isHidden = false;
                    
                    func displayPanoImage(image: UIImage?) {
                        cell.placeholderImageView.isHidden = true
                        DispatchQueue.main.async {
                            cell.imageView.image = image
                            cell.imageView.contentMode = .scaleToFill
                        }
                    }
                    
                    cell.placeholderImageView.image = UIImage(named: "interior360")
                    
                    if vehicelObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue {
                        let thumbUrlPath = (FFHelper.app.getDirectoryPath(photoPath: "\(vehicelObject.rooftopID!)/\(vehicelObject.iLotId!)/\(vehicelObject.vin!)") as NSURL)
                        let thumbStringPath: String = thumbUrlPath.absoluteString ?? ""
                        
                        FFSpinManager.sharedService().requestInteriorRemoteThumbnailforFFSpinforiLotID(vehicelObject.iLotId!, vin: vehicelObject.vin!, captureID: vehicelObject.panoId!, thumbFilePath: thumbStringPath, thumbWidth: 400, thumbHeight: 300, successBlock: { (status, message, thumbPath) in
                            print("Interior Status: \(status), Message: \(message), ThumbPath: \(thumbPath)")
                            DispatchQueue.main.async {
                                cell.imageView.image = UIImage.init(contentsOfFile: thumbPath)
                                cell.imageView.contentMode = .scaleToFill
                            }
                            
                        }) { (status, failureMessage) in
                            print("Interior Status: \(status), Failure Message\(failureMessage)")
                        }
                    } else {
                        FFSpinManager.requestThetaThumbnailImage(forIdentifier: vehicelObject.panoId!.components(separatedBy: ":")[1...].joined(separator: ":"), completion: displayPanoImage(image:))
                    }
                } else {
                    cell.deleteButton.isHidden = true;
                    cell.imageView.image = nil
                    cell.placeholderImageView.image = UIImage.init(named: "interior_360_icn")
                }
            }
        }

        return cell
    }
}

extension FFVehicleDetailsController: UICollectionViewDelegate, FFSpinCaptureDelegate {

    private func presentPhoto360(_ vehicleObject: FFVehicleList, isSpinPreview:Bool) {
        guard isSpinPreview else {
            if vehicelObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue {
                FFHelper.app.landScapeOrientation()

                let remoteViewController = FFRemotePreview()
                remoteViewController.iLotId = vehicleObject.iLotId!
                remoteViewController.vin = vehicleObject.vin!
                remoteViewController.localId = vehicleObject.panoId!

                remoteViewController.isExteriorPreview = false
                remoteViewController.modalPresentationStyle = .fullScreen
                self.present(remoteViewController, animated: true, completion: nil)
            } else {
                FFHelper.app.landScapeOrientation()
                let thetasessionNavigationController = FFThetaPreview()
                thetasessionNavigationController.delegate = self
                thetasessionNavigationController.captureID = vehicleObject.panoId!.components(separatedBy: ":")[1...].joined(separator: ":")
                thetasessionNavigationController.modalPresentationStyle = .fullScreen
                present(thetasessionNavigationController, animated: true, completion: nil)
            }
            
            return
        }
        
        if vehicelObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue {
            FFHelper.app.landScapeOrientation()
            
            let remoteViewController = FFRemotePreview()
            remoteViewController.iLotId = vehicleObject.iLotId!
            remoteViewController.vin = vehicleObject.vin!
            remoteViewController.localId = vehicleObject.spinId!
            remoteViewController.isExteriorPreview = true
            remoteViewController.modalPresentationStyle = .fullScreen
            self.present(remoteViewController, animated: true, completion: nil)
        } else {
            FFHelper.app.landScapeOrientation()
            let spinPreviewNavigationController = FFSpinPreview()
            spinPreviewNavigationController.captureId = vehicleObject.spinId!
            spinPreviewNavigationController.modalPresentationStyle = .fullScreen
            self.present(spinPreviewNavigationController, animated: true, completion: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if vehicleSegmentedControl.selectedSegmentIndex == 0 {
            
        } else {
            FFHelper.app.landScapeOrientation()

            if indexPath.row == 0 {
                if vehicelObject.spinId?.count ?? 0 > 0 {

                    let progressStatus  = FFProcessingManager.shared().getProgressStatusforCaptureId(vehicelObject.spinId!);
                    if progressStatus == PROCESS_STATUS.PROCESS_PENDING.rawValue || progressStatus == PROCESS_STATUS.PROCESS_FAILED.rawValue {
                        let cell = collectionView .cellForItem(at: indexPath) as! FFSpin360Cell
                        func showProgress() {
                            DispatchQueue.main.async {
                                cell.visualEffectView.isHidden = false
                                cell.reviewLabel.isHidden = true
                                cell.progressLabel.isHidden = false
                                cell.progressBar.isHidden = false
                                cell.progressLabel.text = "0%"
                                cell.progressBar.setProgress(0.0)
                            }
                        }
                        
                        showProgress()
                        
                        FFSpinProcessController.sharedInstance.processffSpin(vehicleObject: vehicelObject)
                        
                    } else if progressStatus == PROCESS_STATUS.PROCESS_IN_PROGRESS.rawValue {
                        let alert = UIAlertController(title:"Spin process in review",
                                                      message:"Spin processing is in progress. Please wait.", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title:"Ok", style: .cancel, handler: nil))
                        present(alert, animated: true, completion: nil)
                    } else {
                        presentPhoto360(vehicelObject, isSpinPreview: true)
                    }
                } else {
                    guard let captureInfo = FFCaptureInfo(vin: vehicelObject.vin!, carLotId: vehicelObject.iLotId!, rooftopId: vehicelObject.rooftopID!, carUserName: vehicelObject.userName!) else { return }
                    let photo360sessionNavigationController = FFSpinCapture()
                    photo360sessionNavigationController.delegate = self
                    photo360sessionNavigationController.captureInfo = captureInfo
                    photo360sessionNavigationController.modalPresentationStyle = .fullScreen
                    present(photo360sessionNavigationController, animated: false, completion: nil)
                }
            } else {
                if vehicelObject.panoId?.count ?? 0 > 0 {
                    presentPhoto360(vehicelObject, isSpinPreview: false)
                } else {
                    guard let captureInfo = FFCaptureInfo(vin: vehicelObject.vin!, carLotId: vehicelObject.iLotId!, rooftopId: vehicelObject.rooftopID!, carUserName: vehicelObject.userName!) else { return }
                    
                    let thetasessionNavigationController = FFInteriorPanoCapture()
                    thetasessionNavigationController.delegate = self
                    thetasessionNavigationController.captureInfo = captureInfo
                    thetasessionNavigationController.modalPresentationStyle = .fullScreen
                    present(thetasessionNavigationController, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: SPIN CAPTURE DELEGATE METHODS
    
    @objc func spinCaptureDidSave(withIdentifier identifier: String) {
        print("didSaveWithIdentifier \(identifier)")
        if vehicelObject != nil {
            vehicelObject.spinId = identifier
            vehicelObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_PENDING.rawValue
            
            vehicelObject.photosStatus = GET_PHOTOS_STATUS.GET_PHOTOS_PENDING.rawValue
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let dateString = formatter.string(from: date)

            vehicelObject.spinDateForSorting = date
            vehicelObject.spinTimeStamp = dateString
            
            FFDataBaseController.sharedInstance().saveContext()
        }
        collectionView?.reloadData()
    }
    
    @objc func spinCaptureDidDismiss() {
        print("spinCaptureDidDismiss")
    }
    
    // Process
    @objc private func handleSpinProcessSuccessful(notification: Notification) {
        
        DispatchQueue.main.async {
            if self.vehicleSegmentedControl.selectedSegmentIndex == 1 {
                guard (notification.userInfo?["captureId"] as? String) != nil else { return }
                
                if (self.vehicelObject.spinId == notification.userInfo?["captureId"] as? String) {
                    let indexPath = IndexPath(item: 0, section: 0)
                    let cell = self.collectionView.cellForItem(at: indexPath) as! FFSpin360Cell
                    cell.progressLabel.text = "100%"
                    cell.visualEffectView.isHidden = true
                    cell.reviewLabel.isHidden=true
                    cell.progressLabel.isHidden = true
                    cell.progressBar.isHidden = true
                    
                    self.collectionView?.reloadData()
                }
                
            }
        }
    }
    
    @objc private func handleSpinProcessFailed(notification: Notification) {
        
        DispatchQueue.main.async {
            if self.vehicleSegmentedControl.selectedSegmentIndex == 1 {
                guard (notification.userInfo?["captureId"] as? String) != nil else { return }
                
                if (self.vehicelObject.spinId == notification.userInfo?["captureId"] as? String) {
                    let indexPath = IndexPath(item: 0, section: 0)
                    let cell = self.collectionView.cellForItem(at: indexPath) as! FFSpin360Cell
                    cell.visualEffectView.isHidden = true
                    cell.progressLabel.isHidden = true
                    cell.progressBar.isHidden = true
                    cell.reviewLabel.isHidden=true
                    cell.reviewLabel.text = "Processing failed.\n Try again to review."
                    
                    self.collectionView?.reloadData()
                }
                
            }
        }
    }
    
    @objc private func handleSpinProcessProgress(notification: Notification) {
        
        DispatchQueue.main.async {
            if self.vehicleSegmentedControl.selectedSegmentIndex == 1 {
                
                if (self.vehicelObject.spinId == notification.userInfo?["captureId"] as? String) {
                    guard let progress = notification.userInfo?["progress"] as? Float else { return }
                    let progressval = progress * 100
                    let progressValue = String(format: "%.0f%@", progressval,"%")
                    let indexPath = IndexPath(item: 0, section: 0)
                    let cell = self.collectionView.cellForItem(at: indexPath) as! FFSpin360Cell
                    cell.progressLabel.text = progressValue as String
                    cell.progressBar.setProgress(Double(progress))
                }
                
            }
        }
    }
}

extension FFVehicleDetailsController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if vehicleSegmentedControl.selectedSegmentIndex == 0 {
            return CGSize(width: (collectionView.bounds.width-20)/2, height: (collectionView.bounds.width-20)/2)
        } else {
            return CGSize(width: collectionView.bounds.width, height: 200)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //.zero
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if vehicleSegmentedControl.selectedSegmentIndex == 0 {
            return 10
        } else {
            return 10
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if vehicleSegmentedControl.selectedSegmentIndex == 0 {
            return 10
        } else {
            return 10
        }
    }
}

extension FFVehicleDetailsController : FFThetaCaptureDelegate,FFThetaPreviewDelegate {
    // MARK: Theta Capture Delegate Methods
    
    @objc func thetaCaptureDidSave(withIdentifier identifier: String) {
        if vehicelObject != nil {
            vehicelObject.panoId = "THETA:\(identifier)"
            vehicelObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_PENDING.rawValue
            
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm"
            let dateString = formatter.string(from: date)

            vehicelObject.panoDateForSorting = date
            vehicelObject.panoTimeStamp = dateString
            
            FFDataBaseController.sharedInstance().saveContext()
        }
        
        print("thetaCaptureDidSave")
        collectionView?.reloadData()
    }
    
    @objc func thetaCaptureDidDismiss() {
        print("thetaCaptureDidDismiss")
    }
    
    // MARK: Theta Preview Delegate Methods
    
    @objc func thetaPreviewDidComplete(withIdentifier identifier: String) {
        print("thetaPreviewDidComplete")
    }
    
    @objc func thetaPreviewDidDismiss() {
        print("thetaPreviewDidDismiss")
    }
}

extension FFVehicleDetailsController: Photo360CaptureCellDelegate {
    private func deleteExteriorAndInterior(vehicleObject: FFVehicleList) {
        guard vehicelObject.spinId?.count ?? 0 > 0 && vehicelObject.panoId?.count ?? 0 > 0 else { return }
                        
        FFModelPhoto360Controller.sharedInstance.delete(vehicleObject: vehicleObject, deleteType: DELETE_TYPE.DELETE_BOTH.rawValue)

        vehicelObject.spinId = ""
        vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_ERROR.rawValue
        vehicleObject.spinUploadProgress = 0.0
        vehicleObject.remoteSpinId = ""
        vehicleObject.processStatus = ""
        vehicleObject.processProgress = 0.0
        
        vehicelObject.photosStatus = GET_PHOTOS_STATUS.GET_PHOTOS_FAILED.rawValue
        vehicelObject.photosProgress = 0.0
        
        vehicleObject.panoId = ""
        vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_ERROR.rawValue
        vehicleObject.panoUploadProgress = 0.0
        vehicleObject.remotePanoId = ""
        FFDataBaseController.sharedInstance().saveContext()
        
        collectionView?.reloadSections(IndexSet(integer: 0))
    }
    
    private func deleteSpin(vehicleObject: FFVehicleList) {
        guard vehicleObject.spinId?.count ?? 0 > 0 else { return }
        
        if (vehicelObject.photos?.count ?? 0 > 0) {
            FFHelper.app.deleteDirectory(photoPath: "\(vehicleObject.rooftopID!)/\(vehicleObject.iLotId!)/\(vehicleObject.vin!)/EXTRACTED_PHOTOS")
            vehicelObject.photos = ""
        }
        
        FFModelPhoto360Controller.sharedInstance.delete(vehicleObject: vehicleObject, deleteType: DELETE_TYPE.DELETE_EXTERIOR.rawValue)
        
        vehicleObject.spinId = ""
        vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_ERROR.rawValue
        vehicleObject.spinUploadProgress = 0.0
        vehicleObject.remoteSpinId = ""
        vehicleObject.processStatus = ""
        vehicleObject.processProgress = 0.0
        
        vehicleObject.photosStatus = GET_PHOTOS_STATUS.GET_PHOTOS_FAILED.rawValue
        vehicleObject.photosProgress = 0.0
        
        FFDataBaseController.sharedInstance().saveContext()

        collectionView?.reloadSections(IndexSet(integer: 0))
    }
    
    private func deletePano(vehicleObject: FFVehicleList) {
        guard vehicleObject.panoId?.count ?? 0 > 0 else { return }
        
        FFModelPhoto360Controller.sharedInstance.delete(vehicleObject: vehicleObject, deleteType: DELETE_TYPE.DELETE_INTERIOR.rawValue)

        vehicleObject.panoId = ""
        vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_ERROR.rawValue
        vehicleObject.panoUploadProgress = 0.0
        vehicleObject.remotePanoId = ""
        FFDataBaseController.sharedInstance().saveContext()

        collectionView?.reloadSections(IndexSet(integer: 0))
    }
    
    func photo360CaptureCellDidRequestDeletion(_ defaultCell: FFSpin360Cell, index:Int) {
        guard index == 1 else {
            guard vehicelObject.spinId?.count ?? 0 > 0 else { return }
            
            let progressStatus  = FFProcessingManager.shared().getProgressStatusforCaptureId(vehicelObject.spinId!);
            
            if progressStatus == 1 {
               let alert = UIAlertController(title: "Spin process in review",
                                             message: "Spin processing is in progress. Please wait.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
               present(alert, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Are You Sure?", message: "Do you want to delete Exterior 360", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.deleteSpin(vehicleObject: self.vehicelObject)
                }))
                
                alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            
            return
        }
        
        guard vehicelObject.panoId?.count ?? 0 > 0 else { return }
        
        let alertController = UIAlertController(title: "Are You Sure?", message: "Do you want to delete Interior 360", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
            self.deletePano(vehicleObject: self.vehicelObject)
        }))
        
        alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
        
    }
    
    func exteriorAndInteriorDeletion(_ defaultCell: FFSpin360Cell, index:Int) {
        guard index == 1 else {
            guard vehicelObject.spinId?.count ?? 0 > 0 else { return }
            
            let progressStatus  = FFProcessingManager.shared().getProgressStatusforCaptureId(vehicelObject.spinId!);
            
            if progressStatus == 1 {
               let alert = UIAlertController(title: "Spin process in review",
                                             message: "Spin processing is in progress. Please wait.", preferredStyle: .alert)
               alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
               present(alert, animated: true, completion: nil)
            } else {
                let alertController = UIAlertController(title: "Are You Sure?", message: "Do you want to delete Exterior and Interior 360", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Yes", style: .default, handler: { _ in
                    self.deleteExteriorAndInterior(vehicleObject: self.vehicelObject)
                }))
                
                alertController.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                present(alertController, animated: true, completion: nil)
            }
            
            return
        }
    }

}
