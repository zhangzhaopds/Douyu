//
//  NetworkManager.swift
//  Douyu
//
//  Created by 张昭 on 12/12/2016.
//  Copyright © 2016 Jmsp. All rights reserved.
//

import UIKit

class NetworkManager: NSObject {
    
    class var instance: NetworkManager {
        return inner.ins
    }
    
    struct inner {
        static let ins = NetworkManager.init()
    }
    
    func request(urlStr: String, bodyStr: String, complete: @escaping (_ result: [String: Any])->Void) {
        var urlRequest = URLRequest.init(url: URL.init(string: urlStr)!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 6.0)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = bodyStr.data(using: .utf8)
        let session: URLSession = URLSession.init(configuration: URLSessionConfiguration.default)
        let task: URLSessionDataTask = session.dataTask(with: urlRequest, completionHandler: {data, response, error in
            
            if error != nil {
                print("网络请求❎：\(error)")
                return
            }
            
            do {
                let json =
                try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                DispatchQueue.main.async {
                    complete(json as! [String: Any])
                }
            } catch {
                print("网络请求-数据JSON数据解析异常❎")
            }
            
        })
        task.resume()
            
        
    }
}
