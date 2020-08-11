//
//  FFHelper.swift
//  Spin360Host
//
//  Created by apple on 5/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import FFSpinSDK

enum UPLOAD_STATUS: Int64 {
    case UPLOAD_PENDING = 1, UPLOAD_IN_PROGRESS, UPLOAD_COMPLETED, UPLOAD_FAILED, UPLOAD_ERROR
}

enum UPLOAD_TYPE: Int {
    case UPLOAD_BOTH = 1, UPLOAD_EXTERIOR, UPLOAD_INTERIOR
}

enum PROCESS_STATUS: Int {
    case PROCESS_PENDING = 0, PROCESS_IN_PROGRESS,PROCESS_COMPLETED, PROCESS_FAILED
}

enum GET_PHOTOS_STATUS: Int64 {
    case GET_PHOTOS_PENDING = 0, GET_PHOTOS_IN_PROGRESS, GET_PHOTOS_COMPLETED, GET_PHOTOS_FAILED
}

enum DELETE_TYPE: Int {
    case DELETE_BOTH = 1, DELETE_EXTERIOR, DELETE_INTERIOR
}

class FFHelper {
    static var app: FFHelper = {
        return FFHelper()
    }()
    
    let cellBGBlackColor = UIColor.init(displayP3Red: 105/255.0, green: 105/255.0, blue: 105/255.0, alpha: 1.0)
    let cellBGGrayColor = UIColor.init(displayP3Red: 50/255.0, green: 50/255.0, blue: 51/255.0, alpha: 1.0)

    func createLabel (frame: CGRect, fontSize: CGFloat) -> UILabel {
        let lbl = UILabel(frame: frame)
        lbl.textColor = .white
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: fontSize)
        return lbl
    }
    
    func createButton (imageName: String, frame: CGRect) -> UIButton {
        let backgroudColor : UIColor = UIColor.clear
        let textColor : UIColor = UIColor.black
        
        let button:UIButton = UIButton(frame: frame)
//        button.setTitle(title, for: UIControl.State.normal)
        button.setImage(UIImage.init(named: imageName), for: UIControl.State.normal)
        button.backgroundColor = backgroudColor
        button.setTitleColor(textColor, for: UIControl.State.normal)
        return button;
    }
    
    func createImageView(imageName: String, frame: CGRect) -> UIImageView {
        let image = UIImage(named: "cat.jpg")
        
        let imageView:UIImageView = UIImageView(frame: frame)
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        imageView.image = image
        
        return imageView
    }
    
    /**
     Portrait orientation method allows screen to load in Portrait mode
     */
    func portraitOrientation () {
        let orientValue = NSNumber(integerLiteral: UIInterfaceOrientation.portrait.rawValue)
        UIDevice.current.setValue(orientValue, forKey: "orientation")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rotateOrientation = false;
    }
    
    /**
     Landscape orientation method allows screen to load in Landscape mode
     */
    func landScapeOrientation () {
        let orientValue = NSNumber(integerLiteral: Int(UIInterfaceOrientationMask.landscape.rawValue))
        UIDevice.current.setValue(orientValue, forKey: "orientation")
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.rotateOrientation = true;
    }
    
    func checkSpecificVehicleInDB(vin:String) -> NSArray {
        let context: NSManagedObjectContext = FFDataBaseController.sharedInstance().masterManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "FFVehicleList", in: context)!
        let predicate:NSPredicate = NSPredicate(format: "vin == %@", vin)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entity
        
        do {
            let specificVehicleList = try context.fetch(fetchRequest)
            //            let groeperingen = vinList as! [FFVehicleList]
            print(specificVehicleList)
            return specificVehicleList as NSArray
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    func fetchVehiclesFromDb() -> NSArray {
        let context: NSManagedObjectContext = FFDataBaseController.sharedInstance().masterManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "FFVehicleList", in: context)!
        fetchRequest.entity = entity
        do {
            let vehiclesList = try context.fetch(fetchRequest)
            //            let groeperingen = vinList as! [FFVehicleList]
            print(vehiclesList)
            return vehiclesList as NSArray
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    func addVehicles() -> NSMutableArray{
        let vehicleDic1 = NSMutableDictionary()
        vehicleDic1.setValue("2024 Bayliner TISMEN", forKey: "vehicleName")
        vehicleDic1.setValue("3217775", forKey: "iLotID")
        vehicleDic1.setValue("IOSHOMETEST13", forKey: "vin")
        vehicleDic1.setValue("ff360demo", forKey: "userName")
        vehicleDic1.setValue("2278831", forKey: "rooftopId")
        vehicleDic1.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic2 = NSMutableDictionary()
        vehicleDic2.setValue("2022 Bayliner BC", forKey: "vehicleName")
        vehicleDic2.setValue("3217775", forKey: "iLotID")
        vehicleDic2.setValue("RAMREMOTEKEYTEST2", forKey: "vin")
        vehicleDic2.setValue("ff360demo", forKey: "userName")
        vehicleDic2.setValue("2278831", forKey: "rooftopId")
        vehicleDic2.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic3 = NSMutableDictionary()
        vehicleDic3.setValue("2021 Bayliner TISMEN", forKey: "vehicleName")
        vehicleDic3.setValue("3217775", forKey: "iLotID")
        vehicleDic3.setValue("IOSHOMETEST11", forKey: "vin")
        vehicleDic3.setValue("ff360demo", forKey: "userName")
        vehicleDic3.setValue("2278831", forKey: "rooftopId")
        vehicleDic3.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic4 = NSMutableDictionary()
        vehicleDic4.setValue("2020 Acura MDX", forKey: "vehicleName")
        vehicleDic4.setValue("3217775", forKey: "iLotID")
        vehicleDic4.setValue("PHOTO999999999999", forKey: "vin")
        vehicleDic4.setValue("ff360demo", forKey: "userName")
        vehicleDic4.setValue("2278831", forKey: "rooftopId")
        vehicleDic4.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic5 = NSMutableDictionary()
        vehicleDic5.setValue("2020 Acura MDX", forKey: "vehicleName")
        vehicleDic5.setValue("3217775", forKey: "iLotID")
        vehicleDic5.setValue("P1234567890123456", forKey: "vin")
        vehicleDic5.setValue("ff360demo", forKey: "userName")
        vehicleDic5.setValue("2278831", forKey: "rooftopId")
        vehicleDic5.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic6 = NSMutableDictionary()
        vehicleDic6.setValue("2020 Acura MDX", forKey: "vehicleName")
        vehicleDic6.setValue("3217775", forKey: "iLotID")
        vehicleDic6.setValue("P1234512345123451", forKey: "vin")
        vehicleDic6.setValue("ff360demo", forKey: "userName")
        vehicleDic6.setValue("2278831", forKey: "rooftopId")
        vehicleDic6.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic7 = NSMutableDictionary()
        vehicleDic7.setValue("2020 Acura MDX", forKey: "vehicleName")
        vehicleDic7.setValue("3217775", forKey: "iLotID")
        vehicleDic7.setValue("PHOTO123456789009", forKey: "vin")
        vehicleDic7.setValue("ff360demo", forKey: "userName")
        vehicleDic7.setValue("2278831", forKey: "rooftopId")
        vehicleDic7.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic8 = NSMutableDictionary()
        vehicleDic8.setValue("2020 Acura RDX w/A-SPEC Pkg", forKey: "vehicleName")
        vehicleDic8.setValue("3217775", forKey: "iLotID")
        vehicleDic8.setValue("WERTYUASFHJKLHHHD", forKey: "vin")
        vehicleDic8.setValue("ff360demo", forKey: "userName")
        vehicleDic8.setValue("2278831", forKey: "rooftopId")
        vehicleDic8.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic9 = NSMutableDictionary()
        vehicleDic9.setValue("2020 Alfa Romeo $C Spider", forKey: "vehicleName")
        vehicleDic9.setValue("3217775", forKey: "iLotID")
        vehicleDic9.setValue("WEC10SSS928228UFU", forKey: "vin")
        vehicleDic9.setValue("ff360demo", forKey: "userName")
        vehicleDic9.setValue("2278831", forKey: "rooftopId")
        vehicleDic9.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic10 = NSMutableDictionary()
        vehicleDic10.setValue("2020 Audi R8 Coupe V10", forKey: "vehicleName")
        vehicleDic10.setValue("3217775", forKey: "iLotID")
        vehicleDic10.setValue("WEA3ALHD928339237", forKey: "vin")
        vehicleDic10.setValue("ff360demo", forKey: "userName")
        vehicleDic10.setValue("2278831", forKey: "rooftopId")
        vehicleDic10.setValue("iLot 1 - 360 Integration", forKey: "iLotName")

        let vehicleDic11 = NSMutableDictionary()
        vehicleDic11.setValue("2019 Ford Transit Connect Van", forKey: "vehicleName")
        vehicleDic11.setValue("3217776", forKey: "iLotID")
        vehicleDic11.setValue("NM0LS6E22K1405940", forKey: "vin")
        vehicleDic11.setValue("ff360demo", forKey: "userName")
        vehicleDic11.setValue("2278831", forKey: "rooftopId")
        vehicleDic11.setValue("iLot 2 - 360 Integration", forKey: "iLotName")

        let vehicleDic12 = NSMutableDictionary()
        vehicleDic12.setValue("2019 Ford Fusion S", forKey: "vehicleName")
        vehicleDic12.setValue("3217776", forKey: "iLotID")
        vehicleDic12.setValue("3FA6P0G70KR202242", forKey: "vin")
        vehicleDic12.setValue("ff360demo", forKey: "userName")
        vehicleDic12.setValue("2278831", forKey: "rooftopId")
        vehicleDic12.setValue("iLot 2 - 360 Integration", forKey: "iLotName")

        let vehicleDic13 = NSMutableDictionary()
        vehicleDic13.setValue("2019 Ford Escape Titanium", forKey: "vehicleName")
        vehicleDic13.setValue("3217776", forKey: "iLotID")
        vehicleDic13.setValue("1FMCU9J97KUB63030", forKey: "vin")
        vehicleDic13.setValue("ff360demo", forKey: "userName")
        vehicleDic13.setValue("2278831", forKey: "rooftopId")
        vehicleDic13.setValue("iLot 2 - 360 Integration", forKey: "iLotName")

        let vehicleDic14 = NSMutableDictionary()
        vehicleDic14.setValue("2019 Ford F-150 XL", forKey: "vehicleName")
        vehicleDic14.setValue("3217776", forKey: "iLotID")
        vehicleDic14.setValue("1FTEW1E47KKD56930", forKey: "vin")
        vehicleDic14.setValue("ff360demo", forKey: "userName")
        vehicleDic14.setValue("2278831", forKey: "rooftopId")
        vehicleDic14.setValue("iLot 2 - 360 Integration", forKey: "iLotName")

        let vehicleDic15 = NSMutableDictionary()
        vehicleDic15.setValue("2018 Ford Escape SEL", forKey: "vehicleName")
        vehicleDic15.setValue("3217776", forKey: "iLotID")
        vehicleDic15.setValue("1FMCU0HD6JUB85654", forKey: "vin")
        vehicleDic15.setValue("ff360demo", forKey: "userName")
        vehicleDic15.setValue("2278831", forKey: "rooftopId")
        vehicleDic15.setValue("iLot 2 - 360 Integration", forKey: "iLotName")

        let vehicleListArray:NSMutableArray = [vehicleDic1, vehicleDic2, vehicleDic3, vehicleDic4, vehicleDic5,vehicleDic6,vehicleDic7,vehicleDic8,vehicleDic9,vehicleDic10,vehicleDic11,vehicleDic12,vehicleDic13,vehicleDic14,vehicleDic15]
        return vehicleListArray
    }
    
    func insertVehiclesIntoDB(vehicleListArray:NSMutableArray) {
        if let array = vehicleListArray as? [[String:String]] {
            for vehicleDic in array {
                print("Vehicle Data:\(vehicleDic)")
                
                let context: NSManagedObjectContext = FFDataBaseController.sharedInstance().masterManagedObjectContext()
                
                if FFHelper.app.checkSpecificVehicleInDB(vin: vehicleDic["vin"]!).count > 0 {
                    let vehicleObject = FFHelper.app.checkSpecificVehicleInDB(vin: vehicleDic["vin"]!)[0] as! FFVehicleList
                    print("Record already existed: \(vehicleObject)")
                } else {
                    let vehicleObject = NSEntityDescription.insertNewObject(forEntityName: "FFVehicleList", into: context) as! FFVehicleList
                    
                    vehicleObject.vehicleName = vehicleDic["vehicleName"]
                    vehicleObject.iLotId = vehicleDic["iLotID"]
                    vehicleObject.vin = vehicleDic["vin"]
                    vehicleObject.userName = vehicleDic["userName"]
                    vehicleObject.rooftopID = vehicleDic["rooftopId"]
                    vehicleObject.iLotName = vehicleDic["iLotName"]
                }
                
                FFDataBaseController.sharedInstance().saveContext()
            }
        }
    }
    
    func fetchVehiclesUsingCaptureIdFromDb(captureId:String) -> NSArray {
        let context: NSManagedObjectContext = FFDataBaseController.sharedInstance().masterManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "FFVehicleList", in: context)!
        let predicate:NSPredicate = NSPredicate(format: "spinId == %@ || panoId == %@",captureId,captureId)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entity
        do {
            let vehiclesList = try context.fetch(fetchRequest)
            //            let groeperingen = vinList as! [FFVehicleList]
            print(vehiclesList)
            return vehiclesList as NSArray
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    func fetchUploadInProgressVehicles() -> NSArray {
        let context: NSManagedObjectContext = FFDataBaseController.sharedInstance().masterManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "FFVehicleList", in: context)!
        let predicate:NSPredicate = NSPredicate(format: "spinUploadStatus == %d || panoUploadStatus == %d",2,2)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entity
        do {
            let vehiclesList = try context.fetch(fetchRequest)
            //            let groeperingen = vinList as! [FFVehicleList]
            print(vehiclesList)
            return vehiclesList as NSArray
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    func updateVehicleStatusInprogressToFailedInDB() {
        let context: NSManagedObjectContext = FFDataBaseController.sharedInstance().masterManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "FFVehicleList", in: context)!
        let predicate:NSPredicate = NSPredicate(format: "spinUploadStatus == %d && panoUploadStatus == %d",UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue,UPLOAD_STATUS.UPLOAD_COMPLETED.rawValue)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entity
        do {
            let vehiclesList = try context.fetch(fetchRequest)
            
            for vehicleDic:FFVehicleList in vehiclesList as! [FFVehicleList] {
                if vehicleDic.spinUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue {
                    vehicleDic.spinUploadStatus = UPLOAD_STATUS.UPLOAD_FAILED.rawValue
                    vehicleDic.spinUploadProgress = 0.0
                }
                
                if vehicleDic.panoUploadStatus == UPLOAD_STATUS.UPLOAD_IN_PROGRESS.rawValue {
                    vehicleDic.panoUploadStatus = UPLOAD_STATUS.UPLOAD_FAILED.rawValue
                    vehicleDic.panoUploadProgress = 0.0
                }
                
                FFDataBaseController.sharedInstance().saveContext()
            }

            print(vehiclesList)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func cleanupExteriorUploadedVehicles(pastDate : Date) -> NSArray {
        let context: NSManagedObjectContext = FFDataBaseController.sharedInstance().masterManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "FFVehicleList", in: context)!
        let predicate:NSPredicate = NSPredicate(format: "remoteSpinId != NULL && remoteSpinId != '' && spinDateForSorting < %@",pastDate as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entity
        do {
            let vehiclesList = try context.fetch(fetchRequest)
            print(vehiclesList)
            return vehiclesList as NSArray
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    func cleanupInteriorUploadedVehicles(pastDate : Date) -> NSArray {
        let context: NSManagedObjectContext = FFDataBaseController.sharedInstance().masterManagedObjectContext()
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let entity:NSEntityDescription = NSEntityDescription.entity(forEntityName: "FFVehicleList", in: context)!
        let predicate:NSPredicate = NSPredicate(format: "remotePanoId != NULL && remotePanoId != '' && panoDateForSorting < %@",pastDate as CVarArg)
        fetchRequest.predicate = predicate
        fetchRequest.entity = entity
        do {
            let vehiclesList = try context.fetch(fetchRequest)
            print(vehiclesList)
            return vehiclesList as NSArray
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        return []
    }
    
    func cleanup(photoRetentionPeriod : Int) {
        guard !deleteAllPastRetentionPeriod(photoRetentionPeriod: photoRetentionPeriod) else {
            FFSpinCacheManager.shared().diskClearFromCurrentDateWithTimeInterval(inDays: Int32(photoRetentionPeriod))
            return
        }
    }
    
    func deleteAllPastRetentionPeriod(photoRetentionPeriod : Int) -> Bool {
        var timeInterval = DateComponents()
        timeInterval.month = 0
        timeInterval.day = -photoRetentionPeriod
        timeInterval.hour = 0
        timeInterval.minute = 0
        timeInterval.second = 0
        guard let pastDate = Calendar.current.date(byAdding: timeInterval, to: Date()) else { return false }
        
        let exteriorArray:NSArray = self.cleanupExteriorUploadedVehicles(pastDate: pastDate)
        
        let interiorArray:NSArray = self.cleanupInteriorUploadedVehicles(pastDate: pastDate)
        
        if (exteriorArray.count > 0 || interiorArray.count > 0) {
            
            for vehicleObject:FFVehicleList in exteriorArray as! [FFVehicleList] {
                vehicleObject.spinId = ""
                vehicleObject.spinUploadStatus = UPLOAD_STATUS.UPLOAD_ERROR.rawValue
                vehicleObject.spinUploadProgress = 0.0
                vehicleObject.remoteSpinId = ""
                vehicleObject.processStatus = ""
                vehicleObject.processProgress = 0.0
                
                vehicleObject.photosStatus = GET_PHOTOS_STATUS.GET_PHOTOS_FAILED.rawValue
                vehicleObject.photosProgress = 0.0
                
                FFDataBaseController.sharedInstance().saveContext()
            }
            
            for vehicleObject:FFVehicleList in interiorArray as! [FFVehicleList] {
                vehicleObject.panoId = ""
                vehicleObject.panoUploadStatus = UPLOAD_STATUS.UPLOAD_ERROR.rawValue
                vehicleObject.panoUploadProgress = 0.0
                vehicleObject.remotePanoId = ""
                
                FFDataBaseController.sharedInstance().saveContext()
            }
            return true
        } else {
            return false
        }
    }
    
    func convertIntoJSONString(arrayObject: NSMutableArray) -> String? {
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    func convertIntoJSONArray(string:String) -> NSMutableArray? {
        let data = string.data(using: .utf8)!
        do {
            if let photosArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [Dictionary<String,Any>]
            {
               // use the json here
                let resultArray: NSMutableArray = NSMutableArray(array: photosArray)
                print("Photos Array : \(resultArray)")
                
                return resultArray

            } else {
                print("bad json")
            }
        } catch let error as NSError {
            print(error)
        }
        
        return []
    }
    
    func configurePhotosDirectory(vehicleObject: FFVehicleList) -> String {
        
        let fileManager = FileManager.default
        
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(vehicleObject.rooftopID!)/\(vehicleObject.iLotId!)/\(vehicleObject.vin!)/EXTRACTED_PHOTOS")
        
        print("Extracted Photos Path: \(path)")
        
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        return path
        
    }
    
    func savePhotoDocumentDirectory(vehicleObject: FFVehicleList, imageData: Data, imageName: String) {
        
        let fileManager = FileManager.default
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(vehicleObject.rooftopID!)/\(vehicleObject.iLotId!)/\(vehicleObject.vin!)/EXTRACTED_PHOTOS")
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let url = NSURL(string: path)
        let imagePath = url!.appendingPathComponent(imageName)
        let urlString: String = imagePath!.absoluteString
        //let imageData = UIImagePNGRepresentation(image)
        fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
        
    }
    
    func getDirectoryPath(photoPath:String) -> NSURL {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(photoPath)
        let url = NSURL(string: path)
        return url!
    }
    
    func getPhotoFromDocumentDirectory(photoPath:String) -> String {
        let fileManager = FileManager.default
        let imagePath = (self.getDirectoryPath(photoPath: photoPath) as NSURL)
        let urlString: String = imagePath.absoluteString ?? ""
        if fileManager.fileExists(atPath: urlString) {
            return urlString
        } else {
            // print("No Image")
        }
        
        return ""
    }
    
    func deleteDirectory(photoPath:String) {
        let fileManager = FileManager.default
        let yourProjectImagesPath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(photoPath)
        if fileManager.fileExists(atPath: yourProjectImagesPath) {
            try! fileManager.removeItem(atPath: yourProjectImagesPath)
        }
    }
}
