//
//  HoriCollectionViewCell.swift
//  Douyu
//
//  Created by 张昭 on 13/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit

class HoriCollectionViewCell: UICollectionViewCell {
    
    var horiPicture: String? {
        didSet {
            picImageView.sd_setImage(with: URL.init(string: horiPicture!))
        }
    }
    
    var horiTitle: String? {
        didSet {
            titleLabel.text = horiTitle
        }
    }
    
    let picImageView = UIImageView()
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        picImageView.frame = CGRect.init(x: frame.size.width / 2 - 23.0, y: 0, width: 46, height: 46)
        picImageView.layer.cornerRadius = 23
        picImageView.layer.masksToBounds = true
        addSubview(picImageView)
        
        titleLabel.frame = CGRect.init(x: 0, y: 55, width: frame.size.width, height: 20)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 13.0)
        titleLabel.textColor = UIColor.darkGray
        addSubview(titleLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
