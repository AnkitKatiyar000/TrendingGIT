//
//  Project.swift
//  TrendingGitSwift
//
//  Created by Vinove on 27/10/16.
//  Copyright © 2016 Vinove. All rights reserved.
//

import UIKit
import AFNetworking
import MBProgressHUD

class Project: NSObject {
    
    var projectName: String = ""
    var projectDescription: String = ""
    var projectID: String = ""
    var stars: Int = 0
    var forks: Int = 0
    var developerImage : String = ""
    var developerName: String = ""
    var developerDescription: String = ""
    
    init(json: NSDictionary) {
        
        
        self.projectName = json.value(forKey: "name") as! String! ?? ""
        self.stars = json.value(forKey: "stargazers_count") as! Int!
        self.forks = json.value(forKey: "forks_count") as! Int!
      
        if let descriptionStr = json["description"] as? String {
            self.projectDescription = descriptionStr
            self.developerDescription = descriptionStr
        }
        
        
        if let developerDictionery = json as? [String: AnyObject] {
            if let person = developerDictionery["owner"] as? [String: AnyObject] {
                if let image = person["avatar_url"] as? String {
                    self.developerImage = image
                }
                if let name  = person["login"] as? String {
                self.developerName = name
                }
            }
        }
        
        
        
    }
}

typealias CompletionHandler = (_ success:Bool) -> Void

class ProjectServiceHelper {
    
    var projectListArray = [Project]()
    let manager = AFHTTPSessionManager()
    var dataTask:URLSessionDataTask?
    
   
    func sendRequestForData(searchKey: String ,pageNo: Int, completion: @escaping CompletionHandler){
       
        let url = NSURL(string:"https://api.github.com/search/repositories?q=\(searchKey)+language:assembly&sort=stars&order=desc&page=\(pageNo)")
        print("\n\n My url is  \(url) \n\n" );
        let configuration: URLSessionConfiguration = URLSessionConfiguration.default
        let afManager = AFURLSessionManager(sessionConfiguration: configuration)
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(url: url as! URL)
        
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/x-www-form-urlencoded;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept-Encoding")
        urlRequest.setValue("en-US", forHTTPHeaderField: "Accept-Language")
        
        
        if dataTask != nil {
            if dataTask!.state==URLSessionTask.State.running{
                dataTask!.cancel()
            }
}
        
        dataTask =  afManager.dataTask(with: urlRequest as URLRequest){ (data, response, error) in
            
            if(response == nil){
                completion(false)

            }else{
               
                let responseDict:NSDictionary = response as! NSDictionary
                print(responseDict)
                let dataArray = responseDict["items"] as! NSArray;
                if dataArray.count>0{
                    for item in dataArray {
                        let obj = item as! NSDictionary
                        self.projectListArray.append(Project(json:obj))
                    }
                }
                completion(true)
            }
            
        }
        dataTask!.resume()
    }
    
    
    
    
}


