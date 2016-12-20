//
//  ExceptMainCollectionViewCell.swift
//  Douyu
//
//  Created by 张昭 on 09/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit

class ExceptMainCollectionViewCell: UICollectionViewCell, UITableViewDataSource, UITableViewDelegate {
    
    var mTableView: UITableView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        mTableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: frame.size.width, height: frame.size.height), style: .grouped)
        self.contentView.addSubview(mTableView!)
        mTableView?.delegate = self
        mTableView?.dataSource = self
        mTableView?.register(UITableViewCell.self, forCellReuseIdentifier: "reuse")
        print("888")
        self.backgroundColor = UIColor.yellow
        
    }
    
//    override func layoutSubviews() {
//        super.layoutSubviews()
    
//        mTableView?.reloadData()
//    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuse")
        cell?.textLabel?.text = "99999999999999"
        return cell!
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
