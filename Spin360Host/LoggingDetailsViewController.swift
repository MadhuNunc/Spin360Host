//
//  LoggingDetailsViewController.swift
//  Capture360Demo
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit
import CSSpin
import MagicalRecord

class LoggingDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CSModuleSyncDelegate  {
    var logType: NSInteger = 0
    var predicate: NSPredicate!
    
    let cellId = "CaptureCell"
    
    var loggingListTableView: UITableView!
    
    var logList: [LogList]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let button1 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        self.navigationItem.leftBarButtonItem  = button1
        
        CSModuleSync.sharedService().updateLogAndObject(self, andLogType: logType)
        
        logList = LogList.mr_findAllSorted(by: "dateForSorting", ascending: false, with:predicate) as? [LogList]
        self.cofigureTableview()
    }
    
    func cofigureTableview() {
        loggingListTableView = UITableView(frame: self.view.bounds)
        loggingListTableView.register(LoggingTableViewCell.self, forCellReuseIdentifier: cellId)
        loggingListTableView.dataSource = self
        loggingListTableView.delegate = self
        self.view.addSubview(loggingListTableView)
    }
    
    func updateLog(withLogType logType: Int, andMessage message: String?) {
        if (logType == LOG_TYPE.LOG_ERROR.rawValue) {
            predicate = NSPredicate(format: "(logType = '\(Constants.LOG_ERROR)')")
        } else if (logType == LOG_TYPE.LOG_WARN.rawValue)  {
            predicate = NSPredicate(format: "(logType = '\(Constants.LOG_WARN)')")
        } else if (logType == LOG_TYPE.LOG_INFO.rawValue) {
            predicate = NSPredicate(format: "(logType = '\(Constants.LOG_INFO)')")
        } else if (logType == LOG_TYPE.LOG_DEBUG.rawValue) {
            predicate = NSPredicate(format: "(logType = '\(Constants.LOG_DEBUG)')")
        } else if (logType == LOG_TYPE.LOG_TRACE.rawValue) {
            predicate = NSPredicate(format: "(logType = '\(Constants.LOG_TRACE)')")
        }
        
        print("Predicate ===>>>  \(String(describing: Constants.LOG_ERROR))")
        
        logList = LogList.mr_findAllSorted(by: "dateForSorting", ascending: false, with:predicate) as? [LogList]
        
        print("Captured List: \(String(describing: logList))")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm"
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        formatter.locale = locale as Locale
        let result = formatter.string(from: date)
        
        let listObject : LogList! = LogList.mr_createEntity()
        
        if (logType == LOG_TYPE.LOG_ERROR.rawValue) {
            listObject.logName = "Error \(logList.count+1)"
            listObject.logType = Constants.LOG_ERROR
        } else if (logType == LOG_TYPE.LOG_WARN.rawValue)  {
            listObject.logName = "Warn \(logList.count+1)"
            listObject.logType = Constants.LOG_WARN
        } else if (logType == LOG_TYPE.LOG_INFO.rawValue) {
            listObject.logName = "Info \(logList.count+1)"
            listObject.logType = Constants.LOG_INFO
        } else if (logType == LOG_TYPE.LOG_DEBUG.rawValue) {
            listObject.logName = "Debug \(logList.count+1)"
            listObject.logType = Constants.LOG_DEBUG
        } else if (logType == LOG_TYPE.LOG_TRACE.rawValue) {
            listObject.logName = "Trace \(logList.count+1)"
            listObject.logType = Constants.LOG_TRACE
        }
        
        listObject.timeStamp = result
        listObject.dateForSorting = date
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
        logList = LogList.mr_findAllSorted(by: "dateForSorting", ascending: false, with:predicate) as? [LogList]
        loggingListTableView.reloadData()
    }
    
    @objc func cancelTapped() {
        CSModuleSync.sharedService().stopProgress()
        self.dismiss(animated: true, completion: nil)
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(logList[indexPath.row])")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80 //80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = LoggingTableViewCell(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 80), reuseIdentifier: cellId)
        
        let logObject = logList[indexPath.row]

        cell.logNameLabel.text = logObject.logName
        cell.timeStampLabel.text = logObject.timeStamp
        
        return cell
    }
}
