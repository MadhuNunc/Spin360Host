//
//  FFSpin360TableViewCell.swift
//  Spin360Host
//
//  Created by apple on 6/11/19.
//  Copyright © 2019 apple. All rights reserved.
//

import UIKit

class FFSpin360TableViewCell: UITableViewCell {
    var thumbImage: UIImageView!
    var spinNameLabel: UILabel!
    var timeStampLabel: UILabel!
    var statusLabel: UILabel!

    init(frame: CGRect, reuseIdentifier: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        
        thumbImage = UIImageView(image: UIImage.init(imageLiteralResourceName: "360-icon"))
        thumbImage.frame = CGRect(x: 20, y: 25, width: 60, height: 60)
        thumbImage.contentMode = .scaleAspectFit
        thumbImage.clipsToBounds = true
        
        spinNameLabel = self.createLabel(frame: CGRect(x: thumbImage.frame.origin.x+thumbImage.frame.size.width+20, y: 10, width: frame.size.width-(thumbImage.frame.size.width+20+20), height: 20), fontSize: 14)
        spinNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        timeStampLabel = self.createLabel(frame: CGRect(x: thumbImage.frame.origin.x+thumbImage.frame.size.width+20, y: spinNameLabel.frame.origin.y+spinNameLabel.frame.size.height+10, width: frame.size.width-(thumbImage
            .frame.size.width+20+20), height: 30), fontSize: 13)
        
        statusLabel = self.createLabel(frame: CGRect(x: thumbImage.frame.origin.x+thumbImage.frame.size.width+20, y: timeStampLabel.frame.origin.y+timeStampLabel.frame.size.height+10, width: (frame.size.width-(thumbImage
            .frame.size.width+20+20)), height: 20), fontSize: 12)
        
        addSubview(thumbImage)
        addSubview(spinNameLabel)
        addSubview(timeStampLabel)
        addSubview(statusLabel)
    }
    
    func createLabel (frame: CGRect, fontSize: CGFloat) -> UILabel {
        let lbl = UILabel(frame: frame)
        lbl.textColor = .black
        lbl.textAlignment = .left
        lbl.font = UIFont.systemFont(ofSize: fontSize)
        return lbl
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
