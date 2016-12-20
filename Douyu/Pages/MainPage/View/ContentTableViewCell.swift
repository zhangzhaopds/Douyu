//
//  ContentTableViewCell.swift
//  Douyu
//
//  Created by 张昭 on 12/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit

class ContentTableViewCell: UITableViewCell {
    
    var mCollectionView: UICollectionView?
    let mPartImageView = UIImageView()
    let mPartTitleLabel = UILabel()
    var mReuseString = ""
    var mRooms: [RoomInfoView]? = []
    
    var mMoreData: [String: Any]? {
        didSet {
            
            mPartTitleLabel.text = mMoreData?["tag_name"] as? String
            let roomArr = mMoreData?["room_list"] as? [[String: Any]]?
            for i in 0..<(mRooms?.count)! {
                let room = mRooms?[i]
                room?.mRoomInfo = roomArr??[i]
            }
        }
    }
    
    var mDataArray: [[String: Any]]? {
        didSet {
            if mReuseString == "content-reuse-girl" {
                print("-------")
                print(mDataArray?.count)
            }
            
            //  && (mDataArray?.count)! == (mRooms?.count)!
            // 最热 颜值
            if (mRooms?.count)! > 0 && (mDataArray?.count)! > 0 {
                for i in 0..<(mRooms?.count)! {
                    let room = mRooms?[i]
                    room?.mRoomInfo = mDataArray?[i]
                }
            }
        }
    }
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        // 图片
        mPartImageView.frame = CGRect.init(x: 5, y: 9, width: 20, height: 20)
        
        // 标题
        mPartTitleLabel.frame = CGRect.init(x: 30, y: 9, width: 80, height: 20)
        mPartTitleLabel.font = UIFont.systemFont(ofSize: 15)
        mPartTitleLabel.textColor = UIColor.darkGray
        

        
        var rooms: Int = 0
        if reuseIdentifier == "content-reuse-hot" {
            print("最热")
            rooms = 8
            mPartImageView.image = #imageLiteral(resourceName: "dy_fire")
        } else if reuseIdentifier == "content-reuse-girl" {
            print("00000")
            rooms = 4
            mPartImageView.image = #imageLiteral(resourceName: "dy_girl")
            mPartTitleLabel.text = "颜值"
        } else {
            rooms = 4
            mPartImageView.image = #imageLiteral(resourceName: "dy_qita")
        }
        mReuseString = reuseIdentifier!
        
        
        // 更多
        let moreBtn = UIButton.init(type: .custom)
        moreBtn.frame = CGRect.init(x: kScreenWidth - 55, y: 9, width: 50, height: 20)
        moreBtn.setImage(#imageLiteral(resourceName: "dy_more"), for: .normal)
//        moreBtn.setTitle("更多", for: .normal)
//        moreBtn.setTitleColor(UIColor.gray, for: .normal)
        
        // 按钮
//        let moreImg = UIImageView.init(frame: CGRect.init(x: kScreenWidth - 25, y: 9, width: 20, height: 20))
        
        self.contentView.addSubview(mPartImageView)
        self.contentView.addSubview(mPartTitleLabel)
        self.contentView.addSubview(moreBtn)
//        self.contentView.addSubview(moreImg)
        
        // 40 145 * 4 580
//        mPartImageView.backgroundColor = UIColor.orange
//        moreImg.backgroundColor = UIColor.orange
        
        for i in 0..<rooms/2 {
            for j in 0..<2 {
                let room = RoomInfoView.init(frame: CGRect.init(x: 5 + CGFloat(j) * (kScreenWidth / 2 - 7.5 + 5), y: 40 + 145.0 * CGFloat(i), width: kScreenWidth / 2 - 7.5, height: 145.0))
                room.backgroundColor = UIColor.white
                room.layer.masksToBounds = true
                self.contentView.addSubview(room)
                mRooms?.append(room)
            }
        }
    }
    
    
    
    
    
    
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
