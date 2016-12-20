//
//  LoopTableViewCell.swift
//  Douyu
//
//  Created by 张昭 on 12/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit


class LoopTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate {
    
    var mScrollView: UIScrollView?
    var mCollectionView: UICollectionView?
    var timer: Timer?
    var mPageControl: UIPageControl?
    var loopInfoArray: [[String: Any]]? = []
    var horiInfoArray: [[String: Any]]? = []
    
    var imgArr: [String]? = []
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        // 数据请求
        dataRequest()
        
        // 滚动视图
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = CGSize.init(width: kScreenWidth * 2 / 9, height: 75.0)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 1.0
        
        mCollectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 145.0, width: kScreenWidth, height: 95.0), collectionViewLayout: layout)
        self.contentView.addSubview(mCollectionView!)
        mCollectionView?.register(HoriCollectionViewCell.self, forCellWithReuseIdentifier: "reuse")
        mCollectionView?.delegate = self
        mCollectionView?.dataSource = self
        mCollectionView?.backgroundColor = UIColor.white
        mCollectionView?.showsHorizontalScrollIndicator = false
        
        
        
    }
    
    // MARK: 数据请求
    func dataRequest() {
        
        // 轮播图数据
        NetworkManager.instance.request(urlStr: "http://capi.douyucdn.cn/api/v1/slide/6", bodyStr: "version=2.410&client_sys=ios", complete: { result in
            
            if result["error"] as! Bool != false {
                print(result["error"] ?? "空")
                return
            }
            
            self.loopInfoArray = result["data"] as! [[String : Any]]?

            // 更新轮播图UI
            self.refreshLoopImageData()
            
        })
        
        // 横向分类
        NetworkManager.instance.request(urlStr: "http://capi.douyucdn.cn/api/v1/getHotCate", bodyStr: "aid=ios&client_sys=ios&time=1481182200&auth=9436a5ab785d444b3fbfd8758d3c8139", complete: { result in
            
            if result["error"] as! Bool != false {
                print(result["error"] ?? "空")
                return
            }
            
            self.horiInfoArray = result["data"] as! [[String: Any]]?
            
            // 横向分类
            self.mCollectionView?.reloadData()
            
        })
    }
    
    
    
    // 更新轮播图UI
    func refreshLoopImageData() {
        
        imgArr?.removeAll()
        
        for dic in loopInfoArray! {
            imgArr?.append(dic["pic_url"] as! String)
        }
        
        // 轮播图
        mScrollView = UIScrollView.init(frame: CGRect.init(x: 0.0, y: 0.0, width: kScreenWidth, height: 145.0))
        self.contentView.addSubview(mScrollView!)
        mScrollView?.isPagingEnabled = true
        mScrollView?.delegate = self
        mScrollView?.contentSize = CGSize.init(width: CGFloat((imgArr?.count)! + 1) * kScreenWidth, height: 0)
        for i in 0..<(imgArr?.count)! {
            let imageView = UIImageView.init(frame: CGRect.init(x: CGFloat(i) * kScreenWidth, y: 0, width: kScreenWidth, height: 145.0))
            imageView.isUserInteractionEnabled = true
            imageView.sd_setImage(with: URL.init(string: (imgArr?[i])!), placeholderImage: nil, options: SDWebImageOptions.delayPlaceholder)
            mScrollView?.addSubview(imageView)
        }
        let imgV = UIImageView.init(frame: CGRect.init(x: CGFloat((imgArr?.count)!) * kScreenWidth, y: 0, width: kScreenWidth, height: 145.0))
        mScrollView?.addSubview(imgV)
        
        // page
        mPageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: 127, width: kScreenWidth - 50.0, height: 15))     // -50.0为了修正pagecontrol的中心点
        mPageControl?.currentPageIndicatorTintColor = UIColor.orange
        self.contentView.addSubview(mPageControl!)
        mPageControl?.numberOfPages = (imgArr?.count)!
        mPageControl?.currentPage = 0
        
        // 计时器
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(autoScroll(scrollView:)), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.defaultRunLoopMode)

    }
    
    func autoScroll(scrollView: UIScrollView) {
        
        if mScrollView!.contentOffset.x <= CGFloat((imgArr?.count)! - 1) * kScreenWidth {
            mScrollView!.setContentOffset(CGPoint.init(x: mScrollView!.contentOffset.x + kScreenWidth, y: 0), animated: true)
        }
    }
    
    // MARK: collectionview
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (horiInfoArray?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "reuse", for: indexPath) as! HoriCollectionViewCell
        let dic = self.horiInfoArray?[indexPath.row]
        cell.horiPicture = dic?["icon_url"] as! String?
        cell.horiTitle = dic?["tag_name"] as! String?
        return cell
    }
    
    // MARK: scrollview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.x == CGFloat((imgArr?.count)!) * kScreenWidth {
            mScrollView!.setContentOffset(CGPoint.zero, animated: false)
        }
        mPageControl?.currentPage = Int(mScrollView!.contentOffset.x / kScreenWidth)
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
