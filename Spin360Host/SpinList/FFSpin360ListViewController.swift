//
//  FFSpin360ListViewController.swift
//  Spin360Host
//
//  Created by apple on 6/11/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

protocol FFSpin360ListViewControllerDelegate {
    func didSelectAction(_ sender:FFSpin360ListViewController, captureState: NSInteger, capturedObject: Spin360List)
}

class FFSpin360ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var delegate:FFSpin360ListViewControllerDelegate?
    var captureState: NSInteger = 0
    var listType: String!
    
    let cellId = "CaptureCell"
    
    var spinListTableView: UITableView!
    
    var spin360List: [Spin360List]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button1 = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped)) // action:#selector(Class.MethodName) for swift 3
        self.navigationItem.leftBarButtonItem  = button1
        
        let predicate: NSPredicate
        if (listType == Constants.PROCESS_360 || listType == Constants.PREVIEW_360 || listType == Constants.UPLOAD_360) {
            predicate = NSPredicate(format: "(spinType = '360 Spin')")
        } else {
            predicate = NSPredicate(format: "(spinType = 'Pano')")
        }
        
        spin360List = Spin360List.mr_findAllSorted(by: "dateForSorting", ascending: false, with: predicate) as? [Spin360List]
        print("Captured List: \(String(describing: spin360List))")
        
        self.cofigureTableview()
    }
    
    @objc func cancelTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func cofigureTableview() {
        spinListTableView = UITableView(frame: self.view.bounds)
        spinListTableView.register(FFSpin360TableViewCell.self, forCellReuseIdentifier: cellId)
        spinListTableView.dataSource = self
        spinListTableView.delegate = self
        self.view.addSubview(spinListTableView)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
        print("Value: \(spin360List[indexPath.row])")
        
        self.dismiss(animated: true) {
            self.delegate?.didSelectAction(self, captureState: self.captureState, capturedObject: self.spin360List[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return spin360List.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = FFSpin360TableViewCell(frame:CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 110), reuseIdentifier: cellId)
        
        let spinObject = spin360List[indexPath.row]
        cell.spinNameLabel.text = spinObject.spinName
        cell.timeStampLabel.text = spinObject.timeStamp
        if (listType == Constants.PROCESS_360 || listType == Constants.PREVIEW_360) {
            cell.statusLabel.text = "Process Status: \(spinObject.processStatus ?? "N/A")"
        } else if (listType == Constants.UPLOAD_360) {
            cell.statusLabel.text = "Upload Status: \(spinObject.uploadStatus ?? "N/A")"
        } else {
            cell.statusLabel.text = "Upload Status: \(spinObject.uploadStatus ?? "N/A")"
        }
        return cell
    }
}
