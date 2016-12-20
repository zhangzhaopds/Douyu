//
//  SegmentHoriView.swift
//  Douyu
//
//  Created by 张昭 on 12/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit

typealias SegmentBtnClickedClosure = (_ tag: Int)->Void

class SegmentHoriView: UIView {

    let segmentTiles: [String] = ["推荐", "手游", "娱乐", "游戏", "趣玩"]
    let segmentLineView = UIView()
    var btnArr: [UIButton]? = []
    var width: CGFloat = 0.0
    var height: CGFloat = 0.0
    var mClosure: SegmentBtnClickedClosure?
    
    var offsetChanged: CGPoint? {
        didSet {
            
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let btnWidth = frame.size.width / 5
        let btnheight = frame.size.height - 3
        width = btnWidth
        height = btnheight
        
        for i in 0..<5 {
            let btn = UIButton.init(type: .custom)
            addSubview(btn)
            btn.frame = CGRect.init(x: CGFloat(i) * btnWidth, y: 0, width: btnWidth, height: btnheight)
            btn.setTitleColor(UIColor.black, for: .normal)
            if i==0 {
                btn.setTitleColor(UIColor.orange, for: .normal)
            }
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            btn.setTitle(segmentTiles[i], for: .normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(SegmentHoriView.clickSegmentBtn(sender:)), for: .touchUpInside)
            self.btnArr?.append(btn)
        }
        
        // 平移线
        segmentLineView.frame = CGRect.init(x: 10, y: btnheight, width: btnWidth - 20, height: 3)
        addSubview(segmentLineView)
        segmentLineView.backgroundColor = UIColor.orange
        
    }
    
    // 点击事件
    func clickSegmentBtn(sender: UIButton) {
        mClosure!(sender.tag)
        moveOrangeLineViewToPoint(pointX: 10.0 + width * CGFloat(sender.tag))
    }
    
    // 移动黄线
    func moveOrangeLineViewToPoint(pointX: CGFloat) {
        let mm = (pointX - 10.0).truncatingRemainder(dividingBy: width)
        let nn = (pointX - 10.0) / width
        
        UIView.animate(withDuration: 0.2, animations: {
            
            // 位置
            self.segmentLineView.frame = CGRect.init(x: pointX, y: self.height, width: self.width - 20, height: 3)
            
            // 颜色
            if mm == 0.0 {
                let btn: UIButton = self.btnArr![Int(nn)]
                btn.setTitleColor(UIColor.orange, for: .normal)
                for bb in self.btnArr! {
                    if bb.tag != btn.tag {
                        bb.setTitleColor(UIColor.black, for: .normal)
                    }
                }
            }

        })
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
