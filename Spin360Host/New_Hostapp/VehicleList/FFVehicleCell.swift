//
//  FFVehicleCell.swift
//  Spin360Host
//
//  Created by apple on 5/22/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit

protocol FFVehicleCellCellDelegate : class {
    func upload360(_ defaultCell: FFVehicleCell, index:Int)
    func uploadPano(_ defaultCell: FFVehicleCell, index:Int)
    func uploadBoth(_ defaultCell: FFVehicleCell, index:Int)
    func remote360(_ defaultCell: FFVehicleCell, index:Int)
    func remotePano(_ defaultCell: FFVehicleCell, index:Int)
}

class FFVehicleCell: UITableViewCell {
    weak var delegate: FFVehicleCellCellDelegate?

    var thumbImage: UIImageView!
    var vehicleNameLabel: UILabel!
    var vinNumberLabel: UILabel!
    var iLotIdLabel: UILabel!
    var upload360Button: UIButton!
    var uploadPanoButton: UIButton!
    var uploadBothButton: UIButton!
    var remote360Button: UIButton!
    var remotePanoButton: UIButton!

    init(frame: CGRect, reuseIdentifier: String) {
        super.init(style: UITableViewCell.CellStyle.default, reuseIdentifier: reuseIdentifier)
        
        let xPositionGap: CGFloat = 20.0
        let yPositionGap: CGFloat = 10.0
        let iconSize: CGFloat = (frame.size.width-120)/5

        thumbImage = UIImageView(image: UIImage.init(imageLiteralResourceName: "vehicle_thumb"))
        thumbImage.frame = CGRect(x: xPositionGap, y: yPositionGap, width: 70, height: 70)
        thumbImage.contentMode = .scaleAspectFit
        thumbImage.clipsToBounds = true
        
        vehicleNameLabel = FFHelper.app.createLabel(frame: CGRect(x: thumbImage.frame.origin.x+thumbImage.frame.size.width+xPositionGap, y:yPositionGap, width: frame.size.width-(thumbImage.frame.size.width+(xPositionGap*2)), height: 20), fontSize: 14)
        vehicleNameLabel.font = UIFont.boldSystemFont(ofSize: 14)
        
        vinNumberLabel = FFHelper.app.createLabel(frame: CGRect(x: thumbImage.frame.origin.x+thumbImage.frame.size.width+xPositionGap, y: vehicleNameLabel.frame.origin.y+vehicleNameLabel.frame.size.height, width: frame.size.width-(thumbImage
            .frame.size.width+(xPositionGap*2)), height: 20), fontSize: 13)
        
        iLotIdLabel = FFHelper.app.createLabel(frame: CGRect(x: thumbImage.frame.origin.x+thumbImage.frame.size.width+xPositionGap, y: vinNumberLabel.frame.origin.y+vinNumberLabel.frame.size.height, width: 200, height: 20), fontSize: 12)
        
        upload360Button = FFHelper.app.createButton(imageName: "upload_360_inact_icn", frame: CGRect(x: xPositionGap, y: thumbImage.frame.origin.y+thumbImage.frame.size.height+yPositionGap, width: iconSize, height: iconSize))
        upload360Button.addTarget(self, action: #selector(upload360ButtonAction(_:)), for: UIControl.Event.touchUpInside)

        uploadPanoButton = FFHelper.app.createButton(imageName: "upload_pano_inact_icn", frame: CGRect(x: upload360Button.frame.origin.x+upload360Button.frame.size.width+xPositionGap, y: upload360Button.frame.origin.y, width: iconSize, height: iconSize))
        uploadPanoButton.addTarget(self, action: #selector(uploadPanoButtonAction(_:)), for: UIControl.Event.touchUpInside)

        uploadBothButton = FFHelper.app.createButton(imageName: "upload_both_inact_icn", frame: CGRect(x: uploadPanoButton.frame.origin.x+uploadPanoButton.frame.size.width+xPositionGap, y: upload360Button.frame.origin.y, width: iconSize, height: iconSize))
        uploadBothButton.addTarget(self, action: #selector(uploadBothButtonAction(_:)), for: UIControl.Event.touchUpInside)

        remote360Button = FFHelper.app.createButton(imageName: "remote_360_inact_icn", frame: CGRect(x: uploadBothButton.frame.origin.x+uploadBothButton.frame.size.width+xPositionGap, y: upload360Button.frame.origin.y, width: iconSize, height: iconSize))
        remote360Button.addTarget(self, action: #selector(remote360ButtonAction(_:)), for: UIControl.Event.touchUpInside)

        remotePanoButton = FFHelper.app.createButton(imageName: "remote_pano_inact_icn", frame: CGRect(x: remote360Button.frame.origin.x+remote360Button.frame.size.width+xPositionGap, y: upload360Button.frame.origin.y, width: iconSize, height: iconSize))
        remotePanoButton.addTarget(self, action: #selector(remotePanoButtonAction(_:)), for: UIControl.Event.touchUpInside)

        addSubview(thumbImage)
        addSubview(vehicleNameLabel)
        addSubview(vinNumberLabel)
        addSubview(iLotIdLabel)
        addSubview(upload360Button)
        addSubview(uploadPanoButton)
        addSubview(uploadBothButton)
        addSubview(remote360Button)
        addSubview(remotePanoButton)
    }
    
    @objc func upload360ButtonAction(_ sender: UIButton) {
        self.delegate?.upload360(self, index: upload360Button.tag)
    }
    
    @objc func uploadPanoButtonAction(_ sender: UIButton) {
        self.delegate?.uploadPano(self, index: upload360Button.tag)
    }
    
    @objc func uploadBothButtonAction(_ sender: UIButton) {
        self.delegate?.uploadBoth(self, index: upload360Button.tag)
    }
    
    @objc func remote360ButtonAction(_ sender: UIButton) {
        self.delegate?.remote360(self, index: upload360Button.tag)
    }
    
    @objc func remotePanoButtonAction(_ sender: UIButton) {
        self.delegate?.remotePano(self, index: upload360Button.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
}
