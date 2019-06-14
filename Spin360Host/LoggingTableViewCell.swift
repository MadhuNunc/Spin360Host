//
//  LoggingTableViewCell.swift
//  Capture360Demo
//
//  Created by apple on 6/13/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class LoggingTableViewCell: UITableViewCell {
    var logNameLabel: UILabel!
    var timeStampLabel: UILabel!
    
    init(frame: CGRect, reuseIdentifier: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        
        logNameLabel = self.createLabel(frame: CGRect(x: 20, y: 10, width: frame.size.width-20, height: 30), fontSize: 14)
        timeStampLabel = self.createLabel(frame: CGRect(x: 20, y: logNameLabel.frame.origin.y+logNameLabel.frame.size.height+10, width: logNameLabel.frame.width, height: 20), fontSize: 13)
        timeStampLabel.font = UIFont.systemFont(ofSize: 13)
        addSubview(logNameLabel)
        addSubview(timeStampLabel)
    }
    
    func createLabel (frame: CGRect, fontSize: CGFloat) -> UILabel {
        let lbl = UILabel(frame: frame)
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: fontSize)
        lbl.textAlignment = .left
        return lbl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
