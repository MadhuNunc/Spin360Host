//
//  FFVehicleListController.swift
//  Spin360Host
//
//  Created by apple on 5/22/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import FFSpinSDK

let updateVehiclesList = Notification.Name(rawValue: "updateVehiclesList")

class FFVehicleListController: UIViewController, UITableViewDelegate, UITableViewDataSource, FFVehicleCellCellDelegate {
    let cellId = "CaptureCell"
    var spinListTableView: UITableView!
    var vehicleListArray: NSMutableArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(updateVehiclesUI(notification:)), name: updateVehiclesList, object: nil)

        self.view.backgroundColor = .black
        
        FFHelper.app.insertVehiclesIntoDB(vehicleListArray: FFHelper.app.addVehicles())
        
        self.cofigureTableview()
    }
    
    // Process
    @objc private func updateVehiclesUI(notification: Notification) {
        
        DispatchQueue.main.async {
            guard (notification.userInfo?["captureId"] as? String) != nil else { return }

            self.vehicleListArray = NSMutableArray(array: FFHelper.app.fetchVehiclesFromDb())
            self.spinListTableView.reloadData()
        }
    }
    
    func cofigureTableview() {
        spinListTableView = UITableView(frame: self.view.bounds)
        spinListTableView.register(FFVehicleCell.self, forCellReuseIdentifier: cellId)
        spinListTableView.dataSource = self
        spinListTableView.delegate = self
        spinListTableView.backgroundColor = .clear
        self.view.addSubview(spinListTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if FFUploader.sharedInstance.isAuthorized == false {
            FFUploader.sharedInstance.authorize()
        }
        
        FFHelper.app.portraitOrientation()
        
        vehicleListArray = NSMutableArray(array: FFHelper.app.fetchVehiclesFromDb())
        spinListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vehicleObject = vehicleListArray?[indexPath.row] as! FFVehicleList
        print(vehicleObject);
        
        let vc:FFVehicleDetailsController = FFVehicleDetailsController.init(nibName: nil, bundle: nil)
        vc.vehicelObject = vehicleObject
        let navcon:UINavigationController = UINavigationController.init(rootViewController: vc)
        navcon.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(navcon, animated: true, completion: {

        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vehicleListArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110+50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FFVehicleCell(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 110), reuseIdentifier: cellId)
        cell.selectionStyle = .none
        if (indexPath.row % 2 == 0) {
            cell.backgroundColor = FFHelper.app.cellBGGrayColor
        } else {
            cell.backgroundColor = FFHelper.app.cellBGBlackColor
        }
        cell.delegate = self
        cell.upload360Button.tag = indexPath.row
        cell.uploadPanoButton.tag = indexPath.row
        cell.uploadPanoButton.tag = indexPath.row
        cell.remote360Button.tag = indexPath.row
        cell.remotePanoButton.tag = indexPath.row

        let vehicleObject = vehicleListArray?[indexPath.row] as! FFVehicleList
        cell.vehicleNameLabel.text = vehicleObject.vehicleName
        cell.vinNumberLabel.text = vehicleObject.vin
        cell.iLotIdLabel.text = vehicleObject.iLotName
        
        self.updateUI(vehicleObject: vehicleObject, cell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func upload360(_ defaultCell: FFVehicleCell, index:Int) {
        if FFHelper.app.fetchUploadInProgressVehicles().count > 0 {
            let alert = UIAlertController(title: "Spin/Pano upload in progress",
                                          message: "Spin/Pano upload is in progress. Please wait.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let vehicleObject = vehicleListArray?[index] as! FFVehicleList
            FFUploader.sharedInstance.uploadExterior(vehicleObject: vehicleObject)
        }
    }
    
    func uploadPano(_ defaultCell: FFVehicleCell, index:Int) {
        if FFHelper.app.fetchUploadInProgressVehicles().count > 0 {
            let alert = UIAlertController(title: "Spin/Pano upload in progress",
                                          message: "Spin/Pano upload is in progress. Please wait.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let vehicleObject = vehicleListArray?[index] as! FFVehicleList
            FFUploader.sharedInstance.uploadInterior(vehicleObject: vehicleObject)
        }
    }
    
    func uploadBoth(_ defaultCell: FFVehicleCell, index:Int) {
        if FFHelper.app.fetchUploadInProgressVehicles().count > 0 {
            let alert = UIAlertController(title: "Spin/Pano upload in progress",
                                          message: "Spin/Pano upload is in progress. Please wait.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
        } else {
            let vehicleObject = vehicleListArray?[index] as! FFVehicleList
            FFUploader.sharedInstance.uploadBoth(vehicleObject: vehicleObject)
        }
    }
    
    func remote360(_ defaultCell: FFVehicleCell, index:Int) {
        let vehicleObject = vehicleListArray?[index] as! FFVehicleList
        print(vehicleObject)
                
        FFHelper.app.landScapeOrientation()
 
        let remoteViewController = FFRemotePreview()
        remoteViewController.iLotId = vehicleObject.iLotId!
        remoteViewController.vin = vehicleObject.vin!
        remoteViewController.localId = vehicleObject.spinId!
        remoteViewController.isExteriorPreview = true
        remoteViewController.modalPresentationStyle = .fullScreen
        self.present(remoteViewController, animated: true, completion: nil)
        
    }
    
    func remotePano(_ defaultCell: FFVehicleCell, index:Int) {
        let vehicleObject = vehicleListArray?[index] as! FFVehicleList
        print(vehicleObject)
                
        FFHelper.app.landScapeOrientation()

        let remoteViewController = FFRemotePreview()
        remoteViewController.iLotId = vehicleObject.iLotId!
        remoteViewController.vin = vehicleObject.vin!
        remoteViewController.localId = vehicleObject.panoId!

        remoteViewController.isExteriorPreview = false
        remoteViewController.modalPresentationStyle = .fullScreen
        self.present(remoteViewController, animated: true, completion: nil)
        
    }
    
    func updateUI(vehicleObject:FFVehicleList, cell:FFVehicleCell, indexPath:IndexPath) {
        if vehicleObject.spinId?.count ?? 0 > 0 && vehicleObject.panoId?.count ?? 0 > 0{
            if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue) {
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_act_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = true
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false

            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_act_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = true
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_act_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = true
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
            
            else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_act_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = true
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
            
            else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_act_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = true
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_act_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = true
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_act_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_act_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = true
                cell.remotePanoButton.isUserInteractionEnabled = true
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_act_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = true
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
            
            else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_act_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = true
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_act_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = true
                
            } else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue && vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_act_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = true
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
           
        } else if vehicleObject.spinId?.count ?? 0 > 0 {
            
            if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue) {
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
                
            else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
                
            else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_act_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = true
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
                
            else if (vehicleObject.spinUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_act_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = true
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
            
        } else if vehicleObject.panoId?.count ?? 0 > 0 {
            
            if (vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_PENDING.rawValue) {
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
                
            else if (vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
                
            else if (vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_inact_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_act_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = false
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = true
                
            }
                
            else if (vehicleObject.panoUploadStatus == UPLOAD_STATUS.UPLOAD_FAILED.rawValue){
                
                cell.upload360Button .setImage(UIImage.init(named: "upload_360_inact_icn"), for: UIControl.State.normal)
                cell.uploadPanoButton .setImage(UIImage.init(named: "upload_pano_act_icn"), for: UIControl.State.normal)
                cell.uploadBothButton .setImage(UIImage.init(named: "upload_both_inact_icn"), for: UIControl.State.normal)
                cell.remote360Button .setImage(UIImage.init(named: "remote_360_inact_icn"), for: UIControl.State.normal)
                cell.remotePanoButton .setImage(UIImage.init(named: "remote_pano_inact_icn"), for: UIControl.State.normal)
                
                cell.upload360Button.isUserInteractionEnabled = false
                cell.uploadPanoButton.isUserInteractionEnabled = true
                cell.uploadBothButton.isUserInteractionEnabled = false
                cell.remote360Button.isUserInteractionEnabled = false
                cell.remotePanoButton.isUserInteractionEnabled = false
                
            }
            
        } else {
            cell.upload360Button.isHidden = true
            cell.uploadPanoButton.isHidden = true
            cell.uploadBothButton.isHidden = true
            cell.remote360Button.isHidden = true
            cell.remotePanoButton.isHidden = true
        }
    }
}
