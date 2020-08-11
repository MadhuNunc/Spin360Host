//
//  SpinManager.swift
//  Spin360Host
//
//  Created by apple on 6/27/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import FFSpinSDK

class FFModelPhoto360Controller : NSObject, FFSpinManagerDelegate  {
    class var sharedInstance: FFModelPhoto360Controller {
        struct Singleton {
            static let instance = FFModelPhoto360Controller()
        }
        return Singleton.instance
    }
    
    func delete(vehicleObject:FFVehicleList, deleteType:Int) {
        
        if deleteType == DELETE_TYPE.DELETE_INTERIOR.rawValue {
            guard (vehicleObject.panoId != nil && vehicleObject.panoId != "") else {
                return
            }
            
            let thumbUrlPath = (FFHelper.app.getDirectoryPath(photoPath: "\(vehicleObject.rooftopID!)/\(vehicleObject.iLotId!)/\(vehicleObject.vin!)") as NSURL)
            let thumbStringPath: String = thumbUrlPath.absoluteString ?? ""

            FFSpinManager.sharedService().deleteRemoteThumbnail(withThumbFilePath: thumbStringPath, captureID: vehicleObject.panoId!, isExterior: false, successBlock: { (status, message) in
                print("Interior Status: \(status), Message: \(message)")
            }) { (status, failureMessage) in
                print("Interior Status: \(status), Failure Message\(failureMessage)")
            }
            FFSpinManager.sharedService().delete(withLocalId: vehicleObject.panoId!.components(separatedBy: ":")[1...].joined(separator: ":"), withDeleteType: UInt(deleteType), delegate: self)
        } else {
            guard (vehicleObject.spinId != nil && vehicleObject.spinId != "") else {
                return
            }
            
            let thumbUrlPath = (FFHelper.app.getDirectoryPath(photoPath: "\(vehicleObject.rooftopID!)/\(vehicleObject.iLotId!)/\(vehicleObject.vin!)") as NSURL)
            let thumbStringPath: String = thumbUrlPath.absoluteString ?? ""
            
            FFSpinManager.sharedService().deleteRemoteThumbnail(withThumbFilePath: thumbStringPath, captureID: vehicleObject.spinId!, isExterior: true, successBlock: { (status, message) in
                print("Exterior Status: \(status), Message: \(message)")
            }) { (status, failureMessage) in
                print("Exterior Status: \(status), Failure Message\(failureMessage)")
            }
            
            if deleteType == DELETE_TYPE.DELETE_BOTH.rawValue {
                FFSpinManager.sharedService().deleteRemoteThumbnail(withThumbFilePath: thumbStringPath, captureID: vehicleObject.panoId!, isExterior: false, successBlock: { (status, message) in
                    print("Interior Status: \(status), Message: \(message)")
                }) { (status, failureMessage) in
                    print("Interior Status: \(status), Failure Message\(failureMessage)")
                }
            }
            
            FFSpinManager.sharedService().delete(withLocalId: vehicleObject.spinId!, withDeleteType: UInt(deleteType), delegate: self)
        }
        
    }
    
    //    /*********************************************
    //     Delegate Methods For Exterior/Interior Delete
    //     *********************************************/
    
    func deletedSuccessfully(forCaptureId captureId: String, deleteType: UInt, message: String) {
        DispatchQueue.main.async {
            print("Delete Capture Id: \(captureId) Delete Type: \(deleteType) Message:\(message)")
        }
    }
    
    func deleteFailed(forCaptureId captureId: String, deleteType: UInt, message: String) {
        DispatchQueue.main.async {
            print("Delete Capture Id: \(captureId) Delete Type: \(deleteType) Message:\(message)")
        }
    }
}

/**** FFUpload *****/
class FFUploader : NSObject {
    private var ffAuthManager: FFAuthManager?
    public private(set) var isAuthorized = false

    class var sharedInstance: FFUploader {
        struct Singleton {
            static let instance = FFUploader()
        }
        return Singleton.instance
    }
    
    func authorize() {
        ffAuthManager = FFAuthManager.initialize(withAppID: "voqy4ucTlwAcF32/s0CAG44ts1EbyEJ20KHubTbJ3eU=")
        guard ffAuthManager != nil else {
            return
        }
        isAuthorized = true
    }

    func uploadBoth(vehicleObject:FFVehicleList) {
        vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue
        vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue
        FFDataBaseController.sharedInstance().saveContext()

        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadFailed(notification:)), name: Notification.Name(rawValue: ffBackgroundUploadDidFail), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadSuccessful(notification:)), name: Notification.Name(rawValue: ffBackgroundUploadDidFinish), object: nil)
                
        FFUploadManager.shared()?.uploadSession(withIdentifier: vehicleObject.spinId, withUploadType: UInt(UPLOAD_TYPE.UPLOAD_BOTH.rawValue))
        
        NotificationCenter.default.post(name: updateVehiclesList, object: nil, userInfo: ["captureId" : vehicleObject.spinId!])
    }
    
    func uploadExterior(vehicleObject:FFVehicleList) {
        vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue
        FFDataBaseController.sharedInstance().saveContext()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadFailed(notification:)), name: Notification.Name(rawValue: ffBackgroundUploadDidFail), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadSuccessful(notification:)), name: Notification.Name(rawValue: ffBackgroundUploadDidFinish), object: nil)

        FFUploadManager.shared()?.uploadSession(withIdentifier: vehicleObject.spinId, withUploadType: UInt(UPLOAD_TYPE.UPLOAD_EXTERIOR.rawValue))
        
        NotificationCenter.default.post(name: updateVehiclesList, object: nil, userInfo: ["captureId" : vehicleObject.spinId!])
    }
    
    func uploadInterior(vehicleObject:FFVehicleList) {
        vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue
        FFDataBaseController.sharedInstance().saveContext()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadFailed(notification:)), name: Notification.Name(rawValue: ffBackgroundUploadDidFail), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleUploadSuccessful(notification:)), name: Notification.Name(rawValue: ffBackgroundUploadDidFinish), object: nil)

        FFUploadManager.shared()?.uploadSession(withIdentifier: vehicleObject.panoId, withUploadType: UInt(UPLOAD_TYPE.UPLOAD_INTERIOR.rawValue))
        
        NotificationCenter.default.post(name: updateVehiclesList, object: nil, userInfo: ["captureId" : vehicleObject.panoId!])
    }
    
    private func processSuccess(captureId: String, uploadType:Int) {
        var captureId:String = captureId
        if uploadType == UPLOAD_TYPE.UPLOAD_INTERIOR.rawValue {
            captureId = "THETA:\(captureId)"
        }
        let vehicleListArray:NSMutableArray = NSMutableArray(array: FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId))
        
        if vehicleListArray.count > 0 {
            let vehicleObject:FFVehicleList = vehicleListArray[0] as! FFVehicleList
            
            if uploadType == UPLOAD_TYPE.UPLOAD_BOTH.rawValue {
                vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue
                vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue
                vehicleObject.remoteSpinId = captureId
                vehicleObject.remotePanoId = "THETA:\(captureId)"
            } else if uploadType == UPLOAD_TYPE.UPLOAD_EXTERIOR.rawValue {
                vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue
                vehicleObject.remoteSpinId = captureId
            } else if uploadType == UPLOAD_TYPE.UPLOAD_INTERIOR.rawValue {
                vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue
                vehicleObject.remotePanoId = captureId
            }
            
            FFDataBaseController.sharedInstance().saveContext()
            
            NotificationCenter.default.post(name: updateVehiclesList, object: nil, userInfo: ["captureId" : captureId])
        }
    }
    
    private func processFailure(captureId: String, uploadType:Int) {
        var captureId:String = captureId
        if uploadType == UPLOAD_TYPE.UPLOAD_INTERIOR.rawValue {
            captureId = "THETA:\(captureId)"
        }
        let vehicleListArray:NSMutableArray = NSMutableArray(array: FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId))
        
        if vehicleListArray.count > 0 {
            let vehicleObject:FFVehicleList = vehicleListArray[0] as! FFVehicleList
            
            if uploadType == UPLOAD_TYPE.UPLOAD_BOTH.rawValue {
                vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_FAILED.rawValue
                vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_FAILED.rawValue
                
            } else if uploadType == UPLOAD_TYPE.UPLOAD_EXTERIOR.rawValue {
                vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_FAILED.rawValue
                
            } else if uploadType == UPLOAD_TYPE.UPLOAD_INTERIOR.rawValue {
                vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_FAILED.rawValue
            }
            FFDataBaseController.sharedInstance().saveContext()
            
            NotificationCenter.default.post(name: updateVehiclesList, object: nil, userInfo: ["captureId" : captureId])
        }
    }
    
    //    /*********************************************
    //     Delegate Methods For Exterior/Interior Upload
    //     *********************************************/
    @objc private func handleUploadSuccessful(notification: Notification) {
        guard let captureID = notification.userInfo?["captureId"] as? String else {
                return
        }
        NotificationCenter.default.removeObserver(self)
        DispatchQueue.main.async {
            self.processSuccess(captureId: captureID, uploadType: (notification.userInfo?["uploadType"] as? Int)!)
        }
    }
    
    @objc private func handleUploadFailed(notification: Notification) {
        guard (notification.userInfo?["captureId"] as? String) != nil else {
                return
        }
        NotificationCenter.default.removeObserver(self)
        DispatchQueue.main.async {
            self.processFailure(captureId: (notification.userInfo?["captureId"] as? String)!, uploadType: (notification.userInfo?["uploadType"] as? Int)!)
        }
    }
}
/**** FFSpin Process Delegate Methods**********/

class FFSpinProcessController : NSObject,FFProcessingDelegate {

    class var sharedInstance: FFSpinProcessController {
        struct Singleton {
            static let instance = FFSpinProcessController()
        }
        return Singleton.instance
    }
    
    func processffSpin(vehicleObject:FFVehicleList) {
        FFProcessingManager.shared().processSpin(vehicleObject.spinId!, delegate: self)
    }
        
    //    /*****************************************
    //     Delegate Methods For Exterior 360 PROCESS
    //     *****************************************/
    @objc func spinProcessCompleted(forCaptureId captureId: String) {
        print("Process Completed Response: \(captureId)")
        NotificationCenter.default.post(name: spinProcessDidFinish, object: nil, userInfo: ["captureId" : captureId])
    }
    
    func spinProcessProgress(forCaptureId captureId: String, withProgress progress: Float) {
        print("Process InProgress Response: \(captureId) and Progress:\(progress)")

        NotificationCenter.default.post(name: spinProcessDidUpdateProgress, object: nil, userInfo: ["captureId" : captureId, "progress" : progress])
    }
    
    @objc func spinProcessFailedforCaptureId(_ captureId: String) {
        print("Process Failed Response: \(captureId)")

        NotificationCenter.default.post(name: spinProcessDidFail, object: nil, userInfo: ["captureId" : captureId])
    }
    

    func getPhotos(vehicleObject:FFVehicleList) {
         
        guard (vehicleObject.spinId != nil) else {
            return
        }
        
        vehicleObject.photosStatus = GET_PHOTOS_STATUS.GET_PHOTOS_IN_PROGRESS.rawValue
        vehicleObject.photosProgress = 0.0
        FFDataBaseController.sharedInstance().saveContext()

        FFProcessingManager.shared().getPhotosWithIdentifier(vehicleObject.spinId!, delegate: self)
        
    }

    //    /********************************
    //     Delegate Methods For Get Photos
    //     ********************************/
    func getPhotosSuccess(forCaptureId captureId: String, message: String, photosArray: NSMutableArray) {
        DispatchQueue.main.async {
            print("Get Photos: \(captureId) Message:\(message) Photos Array:\(photosArray)")
            
            let photosDic:NSMutableDictionary = [:]
            photosDic.setValue(captureId, forKey: "captureId")
            photosDic.setValue(message, forKey: "message")
            photosDic.setValue(photosArray, forKey: "photosArray")
            
            if FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId).count > 0 {
                let vehicleObject:FFVehicleList = FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId)[0] as! FFVehicleList
                
                let photosPath:String = FFHelper.app.configurePhotosDirectory(vehicleObject: vehicleObject)
                
                print("Photos Path: \(photosPath)")
                if let array = photosArray as? [[String:Any]] {
                    let photosArray:NSMutableArray = []
                    
                    for photoDic in array {
                        let photoDBDic:NSMutableDictionary = [:]
                        
                        photoDBDic.setValue(photoDic["photoName"]!, forKey: "photoName")
                        photoDBDic.setValue("\(vehicleObject.rooftopID!)/\(vehicleObject.iLotId!)/\(vehicleObject.vin!)/EXTRACTED_PHOTOS/\(captureId)_\(photoDic["photoName"]!).jpeg", forKey: "photoPath")
                        
                        photosArray.add(photoDBDic)
                        
                        FFHelper.app.savePhotoDocumentDirectory(vehicleObject: vehicleObject, imageData: photoDic["photoData"] as! Data, imageName: "\(captureId)_\(photoDic["photoName"]!).jpeg")
                        
                    }
                    
                    print("Photos Array: \(photosArray)")
                    
                    let photoString = FFHelper.app.convertIntoJSONString(arrayObject: photosArray)
                    
                    print("Photo String: \(photoString ?? "")")
                    
                    vehicleObject.photos = photoString
                    vehicleObject.photosStatus = GET_PHOTOS_STATUS.GET_PHOTOS_COMPLETED.rawValue
                    
                    FFDataBaseController.sharedInstance().saveContext()

                }
            }
            
            NotificationCenter.default.post(name: getPhotosUpdateNotify, object: nil, userInfo: photosDic as? [AnyHashable : Any])

        }
    }
    
    func getPhotosFailed(forCaptureId captureId: String, message: String, description: String) {
        DispatchQueue.main.async {
            print("Get Photos: \(captureId) Message:\(message) description:\(description)")
            
            let photosDic:NSMutableDictionary = [:]
            photosDic.setValue(captureId, forKey: "captureId")
            photosDic.setValue(message, forKey: "message")
            photosDic.setValue(description, forKey: "description")
            
            
            if FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId).count > 0 {
                let vehicleObject:FFVehicleList = FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId)[0] as! FFVehicleList
                vehicleObject.photosStatus = GET_PHOTOS_STATUS.GET_PHOTOS_FAILED.rawValue
                vehicleObject.photosProgress = 0.0
            }
          
            NotificationCenter.default.post(name: getPhotosFailedNotify, object: nil, userInfo: photosDic as? [AnyHashable : Any])

        }
    }
    
    func getPhotosProgress(forCaptureId captureId: String, withProgress progress: Float) {
        DispatchQueue.main.async {
            print("Get Photos: \(captureId) Progress:\(progress)")
            
            if FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId).count > 0 {
                let vehicleObject:FFVehicleList = FFHelper.app.fetchVehiclesUsingCaptureIdFromDb(captureId: captureId)[0] as! FFVehicleList
                vehicleObject.photosProgress = progress
            }
            
            NotificationCenter.default.post(name: getPhotosDidUpdateProgress, object: nil, userInfo: ["captureId" : captureId, "progress" : progress])
        }
    }
}
