//
//  MainCollectionViewCell.swift
//  Douyu
//
//  Created by 张昭 on 09/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit

typealias ContentOffsetChangedClosure = (_ newPoint: CGPoint)->Void
typealias ScrollDirectionChangedClosure = (_ oldPoint: CGPoint, _ newPoint: CGPoint)->Void


class MainCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    var mTableView: UITableView?
    var mClosure: ContentOffsetChangedClosure?
    var mScrollClosure: ScrollDirectionChangedClosure?
    var mHotDataArr: [[String: Any]]? = []
    var mMoreDataArr: [[String: Any]]? = []
    var mGirlDataArr: [[String: Any]]? = []
    
    deinit {
        mTableView?.removeObserver(self, forKeyPath: "contentOffset", context: nil)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
       
        mTableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height), style: .grouped)
        self.contentView.addSubview(mTableView!)
        mTableView?.delegate = self
        mTableView?.dataSource = self
        mTableView?.register(LoopTableViewCell.self, forCellReuseIdentifier: "loop-reuse")
        mTableView?.register(ContentTableViewCell.self, forCellReuseIdentifier: "content-reuse-hot")
        mTableView?.register(ContentTableViewCell.self, forCellReuseIdentifier: "content-reuse-girl")
        mTableView?.register(ContentTableViewCell.self, forCellReuseIdentifier: "content-reuse")
        mTableView?.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
        
        // 数据
        dataHandle()
        
    }
    // MARK: 数据请求
    func dataHandle() {
        
        // 最热
        NetworkManager.instance.request(urlStr: "http://capi.douyucdn.cn/api/v1/getbigDataRoom", bodyStr: "client_sys=ios", complete: { result in
            
            if result["error"] as! Bool != false {
                print(result["error"] ?? "空")
                return
            }
            
            self.mHotDataArr?.removeAll()
            self.mHotDataArr = result["data"] as! [[String : Any]]?
            self.mTableView?.reloadData()
        })
        
        // 颜值
        NetworkManager.instance.request(urlStr: "http://capi.douyucdn.cn/api/v1/getVerticalRoom", bodyStr: "limit=4&client_sys=ios&offset=0", complete: { result in
            
            if result["error"] as! Bool != false {
                print(result["error"] ?? "空")
                return
            }
            
            self.mGirlDataArr?.removeAll()
            self.mGirlDataArr = result["data"] as! [[String : Any]]?
            self.mTableView?.reloadData()
        })

        
        // 其他
        NetworkManager.instance.request(urlStr: "http://capi.douyucdn.cn/api/v1/getHotCate", bodyStr: "aid=ios&client_sys=ios&time=1481182200&auth=9436a5ab785d444b3fbfd8758d3c8139", complete: { result in
            
            if result["error"] as! Bool != false {
                print(result["error"] ?? "空")
                return
            }
            
            self.mMoreDataArr?.removeAll()
            self.mMoreDataArr = result["data"] as! [[String: Any]]?
            var k = 1000
            for i in 0..<(self.mMoreDataArr?.count)! {
                let dic = self.mMoreDataArr?[i]
                let roomList = dic?["room_list"] as? [Any]?
                if (roomList??.count)! < 1 {
                    k = i
                }
            }
            if k != 1000 {
                self.mMoreDataArr?.remove(at: k)
            }
            self.mTableView?.reloadData()
        })
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        mTableView?.frame = CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
    
        if keyPath == "contentOffset" {
            if mClosure != nil {
                mClosure!(change?[.newKey] as! CGPoint)
            }
        }
    }
    
    // MARK: scrollview
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 滑动方向闭包
        mScrollClosure!(scrollView.contentOffset, targetContentOffset.pointee)
    }
    
    
    // MARK: tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (mMoreDataArr?.count)! + 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 240.0
        } else if indexPath.section == 1 {
            return 620.0
        } else {
            return 330.0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 0.1
        } else {
            return 10
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            // 轮播图
            let cell = tableView.dequeueReusableCell(withIdentifier: "loop-reuse")
            return cell!
        } else if indexPath.section == 1 {
            // 最热
            let cell = tableView.dequeueReusableCell(withIdentifier: "content-reuse-hot") as! ContentTableViewCell
            cell.mDataArray = mHotDataArr
            return cell
        } else if indexPath.section == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "content-reuse-girl") as! ContentTableViewCell
            cell.mDataArray = mGirlDataArr
            return cell

        } else {
            // 其他
            let cell = tableView.dequeueReusableCell(withIdentifier: "content-reuse") as! ContentTableViewCell
            cell.mMoreData = mMoreDataArr?[indexPath.section - 3]
            
            return cell

        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
