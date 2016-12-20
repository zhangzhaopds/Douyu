//
//  RoomInfoView.swift
//  Douyu
//
//  Created by 张昭 on 13/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit

class RoomInfoView: UIView {

    let mImageView = UIImageView()
    let mRightImageView = UIImageView()
    let mRightLabel = UILabel()
    let mLeftImageView = UIImageView()
    let mLeftLabel = UILabel()
    let mHoriLabel = UILabel()
    
    var mRoomInfo: [String: Any]? {
        didSet {
            mImageView.sd_setImage(with: URL.init(string: mRoomInfo?["room_src"] as! String))
            mHoriLabel.text = mRoomInfo?["room_name"] as? String
            
            let line = mRoomInfo?["online"] as? Int
            mRightLabel.text = "\(line!)"
            mLeftImageView.sd_setImage(with: URL.init(string: mRoomInfo?["avatar_small"] as! String))
            mLeftLabel.text = mRoomInfo?["nickname"] as? String
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mImageView.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: 110.0)
        mImageView.backgroundColor = UIColor.gray
        mImageView.layer.cornerRadius = 5.0
        mImageView.layer.masksToBounds = true
        addSubview(mImageView)
        
        // 右上角
        mRightImageView.frame = CGRect.init(x: frame.size.width - 50, y: 0, width: 17, height: 17)
//        mRightImageView.backgroundColor = UIColor.white
        addSubview(mRightImageView)
        
        mRightLabel.frame = CGRect.init(x: frame.size.width - 33, y: 0, width: 30, height: 17)
        mRightLabel.font = UIFont.systemFont(ofSize: 9)
        mRightLabel.textColor = UIColor.white
        addSubview(mRightLabel)
        
        // 左下方
        mLeftImageView.frame = CGRect.init(x: 3, y: 90.0, width: 20, height: 20)
        addSubview(mLeftImageView)
        mLeftImageView.backgroundColor = UIColor.red
        
        mLeftLabel.frame = CGRect.init(x: 25, y: 90.0, width: frame.size.width - 30, height: 20)
        addSubview(mLeftLabel)
        mLeftLabel.textColor = UIColor.white
        mLeftLabel.font = UIFont.systemFont(ofSize: 11)
        
        
        // 下方
        mHoriLabel.frame = CGRect.init(x: 0, y: 110.0, width: frame.size.width, height: 25)
        addSubview(mHoriLabel)
        mHoriLabel.font = UIFont.systemFont(ofSize: 14)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
