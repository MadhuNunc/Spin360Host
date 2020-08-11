//
//  FFSpin360Cell.swift
//  Spin360Host
//
//  Created by apple on 5/25/20.
//  Copyright © 2020 apple. All rights reserved.
//

import UIKit
import MSCircularProgressView

protocol Photo360CaptureCellDelegate : class {
    func photo360CaptureCellDidRequestDeletion(_ defaultCell: FFSpin360Cell, index:Int)
    func exteriorAndInteriorDeletion(_ defaultCell: FFSpin360Cell, index:Int)
}

class FFSpin360Cell: UICollectionViewCell {
    weak var delegate: Photo360CaptureCellDelegate?

    static var identifier: String = "FFSpin360Cell"

    var textLabel: UILabel!
    var deleteButton: UIButton!
    var imageView: UIImageView!
    var placeholderImageView: UIImageView!
    var visualEffectView: UIView!
    var reviewLabel: UILabel!
    var progressLabel: UILabel!
    var progressBar: MSProgressView!
    var deleteBothButton: UIButton!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.gray
        
        imageView = FFHelper.app.createImageView(imageName: "", frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.height-40))
        self.contentView.addSubview(imageView)

        placeholderImageView = FFHelper.app.createImageView(imageName: "", frame: CGRect(x: (frame.width-150)/2, y: (frame.height-190)/2, width: 150, height: 150))
        self.contentView.addSubview(placeholderImageView)

        textLabel = FFHelper.app.createLabel(frame: CGRect(x: 0, y: frame.height-40, width: frame.width, height: 40), fontSize: 16)
        textLabel.backgroundColor = .darkGray
        self.contentView.addSubview(self.textLabel)

        deleteButton = FFHelper.app.createButton(imageName: "delete360", frame: CGRect(x: frame.width-60, y: frame.height-35, width: 35, height: 35))
        deleteButton.addTarget(self, action: #selector(deleteButtonAction(_:)), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(deleteButton)
        
        deleteBothButton = FFHelper.app.createButton(imageName: "", frame: CGRect(x: deleteButton.frame.origin.x-120, y: frame.height-35, width: 100, height: 35))
        deleteBothButton.addTarget(self, action: #selector(deleteBothButtonAction(_:)), for: UIControl.Event.touchUpInside)
        deleteBothButton.setTitle("Delete Both", for: UIControl.State.normal)
        deleteBothButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.contentView.addSubview(deleteBothButton)
        
        visualEffectView = UIView(frame: CGRect(x: 0.0, y: 0.0, width: frame.width, height: imageView.frame.size.height))
        visualEffectView.backgroundColor = UIColor.black
        visualEffectView.alpha = 0.5
        visualEffectView.isHidden = true
        
        reviewLabel = FFHelper.app.createLabel(frame: CGRect(x: 0.0, y: 0.0, width: 160, height: 42), fontSize: 14.0)
        reviewLabel.textAlignment = NSTextAlignment.center
        reviewLabel.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
        reviewLabel.text = "Process to Review"
        reviewLabel.backgroundColor = .black
        reviewLabel.layer.cornerRadius = 10.0
        reviewLabel.numberOfLines = 2
        reviewLabel.clipsToBounds = true
        reviewLabel.isHidden = true
        
        progressLabel = FFHelper.app.createLabel(frame: CGRect(x: 0.0, y: 0.0, width: 160, height: 32), fontSize: 16.0)
        progressLabel.textAlignment = NSTextAlignment.center
        progressLabel.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
        progressLabel.isHidden = true
        
        progressBar = MSProgressView(frame: CGRect(x: (frame.width - 60)/2, y: (frame.height-60-10)/2, width: 60, height: 60))
        progressBar.setProgress(0.0)
        progressBar.barColor = .green
        progressBar.barWidth = 3.0
        progressBar.isHidden = true
        
        self.imageView.addSubview(self.visualEffectView)
        self.imageView.addSubview(self.reviewLabel)
        self.imageView.addSubview(self.progressBar)
        self.imageView.addSubview(self.progressLabel)
    
    }

    @objc func deleteButtonAction(_ sender: UIButton) {
        self.delegate?.photo360CaptureCellDidRequestDeletion(self, index: deleteButton.tag)
    }
    
    @objc func deleteBothButtonAction(_ sender: UIButton) {
        self.delegate?.exteriorAndInteriorDeletion(self, index: deleteBothButton.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        self.reviewLabel.center = CGPoint(x: self.contentView.center.x, y: self.center.y - 16)
        self.progressBar.center = CGPoint(x: self.contentView.center.x, y: self.center.y - 16)
        self.progressLabel.center =  CGPoint(x: self.contentView.center.x, y: self.center.y - 16)
    }
}
