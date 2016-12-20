//
//  MainVC.swift
//  Douyu
//
//  Created by 张昭 on 08/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit

class MainVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    let naviView = UIView()
    var collectionView: UICollectionView?
    var layout: UICollectionViewFlowLayout?
    var horiView: SegmentHoriView?
    let subBgView = UIView()

//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    deinit {
        collectionView?.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }
    
    // 视图布局
    func initView() {
        
        self.view.addSubview(naviView)
        naviView.mas_makeConstraints { (make) in
            _ = make?.left.and().right().and().top().mas_equalTo()(0)
            _ = make?.height.mas_equalTo()(64)
        }
        naviView.backgroundColor = kMainColor
        
        // logo
        let logoView = UIImageView.init(image: #imageLiteral(resourceName: "Image_launch_logo_72x30_"))
        naviView.addSubview(logoView)
        logoView.mas_makeConstraints { (make) in
            _ = make?.bottom.mas_equalTo()(-7)
            _ = make?.left.mas_equalTo()(10)
            _ = make?.width.mas_equalTo()(72)
            _ = make?.height.mas_equalTo()(30)
        }
        
        //
        subBgView.frame = CGRect.init(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight - 64 - kTabbarHeight)
        self.view.addSubview(subBgView)
        
        horiView = SegmentHoriView.init(frame: CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 40))
        subBgView.addSubview(horiView!)
        horiView?.mClosure = { tag in
            // 同步偏移量
            self.collectionView?.setContentOffset(CGPoint.init(x: CGFloat(tag) * kScreenWidth, y: 0), animated: false)
        }
        
        // collectionView
        layout = UICollectionViewFlowLayout.init()
        layout!.scrollDirection = .horizontal
        layout!.itemSize = CGSize.init(width: kScreenWidth, height: subBgView.frame.size.height - horiView!.frame.size.height)
        layout!.minimumLineSpacing = 0.0;
        
        collectionView = UICollectionView.init(frame: CGRect.init(x: 0, y: 40, width: kScreenWidth, height: subBgView.frame.size.height - horiView!.frame.size.height), collectionViewLayout: layout!)
        
        collectionView?.isPagingEnabled = true
        collectionView?.showsHorizontalScrollIndicator = false
        collectionView?.backgroundColor = UIColor.white
        collectionView?.delegate = self
        collectionView?.dataSource = self
        collectionView?.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: "main-reuse")
        collectionView?.register(ExceptMainCollectionViewCell.self, forCellWithReuseIdentifier: "except-reuse")
        subBgView.addSubview(collectionView!)
        
        // 注册观察者
        collectionView?.addObserver(self, forKeyPath: "contentOffset", options: [.new], context: nil)
    }
    
    // MARK: 观察者
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
            let point = change?[.newKey] as! CGPoint
            horiView?.moveOrangeLineViewToPoint(pointX: 10.0 + point.x / 5)
        }
    }
    
    
    // MARK: - CollectionView 代理
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "main-reuse", for: indexPath) as! MainCollectionViewCell
            // tableview 偏移量回调
            cell.mClosure = {point in
                
            }
            
            // 滑动方向
            cell.mScrollClosure = {oldPoint, newPoint in
                self.scrollDirectionDidChanged(oldPoint: oldPoint, newPoint: newPoint)
            }
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "except-reuse", for: indexPath) as! ExceptMainCollectionViewCell
            return cell
        }
    }
    
    // MARK: 自定义方法
    
    // 滑动方向改变
    func scrollDirectionDidChanged(oldPoint: CGPoint, newPoint: CGPoint) {
        if oldPoint.y < newPoint.y {
            print("向上")
            if oldPoint.y < 0 && newPoint.y == 0.0 {
                return
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.naviView.frame = CGRect.init(x: 0, y: -64, width: kScreenWidth, height: 64)
                self.subBgView.frame = CGRect.init(x: 0, y: 20, width: kScreenWidth, height: kScreenHeight - 20 - kTabbarHeight)
                self.layout!.itemSize = CGSize.init(width: kScreenWidth, height: self.subBgView.frame.size.height - self.horiView!.frame.size.height)
                self.collectionView?.frame = CGRect.init(x: 0, y: 40, width: kScreenWidth, height: self.subBgView.frame.size.height - self.horiView!.frame.size.height)
                self.collectionView?.setNeedsDisplay()
                UIApplication.shared.setStatusBarStyle(.default, animated: true)
                
            })
        } else {
            print("向下")
            UIView.animate(withDuration: 0.2, animations: {
                self.naviView.frame = CGRect.init(x: 0, y: 0, width: kScreenWidth, height: 64)
                self.subBgView.frame = CGRect.init(x: 0, y: 64, width: kScreenWidth, height: kScreenHeight - 64 - kTabbarHeight)
                self.layout!.itemSize = CGSize.init(width: kScreenWidth, height: self.subBgView.frame.size.height - self.horiView!.frame.size.height)
                self.collectionView?.frame = CGRect.init(x: 0, y: 40, width: kScreenWidth, height: self.subBgView.frame.size.height - self.horiView!.frame.size.height)
                self.collectionView?.setNeedsDisplay()
                UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
