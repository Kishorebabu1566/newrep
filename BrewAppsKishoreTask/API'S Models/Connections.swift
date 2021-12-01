//
//  Connections.swift
//  BrewAppsKishoreTask
//
//  Created by Kishore Babu on 30/11/21.
//

import Foundation
import Alamofire

class Connectivity{
    class func isConnectedToInternet() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
}

class Connection
{
    
    class func alert(_ title : String, message : String, view:UIViewController)
    {
        let alert = UIAlertController(title:title, message:  message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
    
    
    
    
    
    func requestPOST(_ url: String, params : Parameters?, headers : HTTPHeaders?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        print("URL = ",url)
        print("Parameter = ",params!)
        
        if Connectivity.isConnectedToInternet()
        {
            if headers == nil
            {
                
                Alamofire.request(url, method: .post, parameters: params!, encoding: URLEncoding.httpBody, headers: nil).responseJSON
                {
                    
                    (responseObject) -> Void in
                    let json = String(data: responseObject.data!, encoding: String.Encoding.utf8)
                    print("Failure Response1: \(json!)")
                    print("Response = ",responseObject)
                    
                    switch responseObject.result
                    {
                    case .success:
                        if let data = responseObject.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                        print(error)
                    }
                    /* if responseObject.result.isSuccess {
                     let resJson = JSON(responseObject.result.value!)
                     success(resJson)
                     }
                     if responseObject.result.isFailure {
                     let error : Error = responseObject.result.error!
                     failure(error)
                     }*/
                }
            }
            else
            {
                
                print("Headers = ",headers!)
                
                Alamofire.request(url, method: .post, parameters: params!, encoding: JSONEncoding.default, headers: headers!).responseJSON
                {
                    (responseObject) -> Void in
                    let json = String(data: responseObject.data!, encoding: String.Encoding.utf8)
                    print("Response1: \(json!)")
                    print("Response = ",responseObject)
                    
                    switch responseObject.result
                    {
                    case .success:
                        if let data = responseObject.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                    
                    /*                if responseObject.result.isSuccess {
                     let resJson = JSON(responseObject.result.value!)
                     success(resJson)
                     }
                     if responseObject.result.isFailure {
                     let error : Error = responseObject.result.error!
                     failure(error)
                     }*/
                }
            }
            
        }
        else
        {
            //            let err = NSError(domain: "Check Internet Connection".localized(), code: nil, userInfo: nil)
            let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : CONSTANT.CHECK_INTERNET_CONNECTION])
            failure(error)
        }
    }
    
    
    func requestGET(_ url: String, params : Parameters?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        print("URL = ",url)
        print("Parameter = ",params)
        print("Headers = ",headers)
        
        
        if Connectivity.isConnectedToInternet()
        {
            do
            {
                Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON
                {
                    (response) in
                    let json = String(data: response.data!, encoding: String.Encoding.utf8)
                    print("Failure Response1: \(json!)")
                    print("Response = ",response)
                    
                    switch response.result
                    {
                    case .success:
                        if let data = response.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
            }
            catch let JSONError as NSError
            {
                
                failure(JSONError)
            }
        }
        else
        {
            //            let err = NSError(domain: "Check Internet Connection".localized(), code: nil, userInfo: nil)
            let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : CONSTANT.CHECK_INTERNET_CONNECTION])
            failure(error)
        }
        
    }
    
    func requestURLEncodingGET(_ url: String, params : Parameters?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        if Connectivity.isConnectedToInternet()
        {
            do
            {
                Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers).responseJSON
                {
                    (response) in
                    let json = String(data: response.data!, encoding: String.Encoding.utf8)
                    print("Failure Response1: \(json!)")
                    print("Response = ",response)
                    
                    switch response.result
                    {
                    case .success:
                        if let data = response.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
            }
            catch let JSONError as NSError
            {
                
                failure(JSONError)
            }
        }
        else
        {
            //            let err = NSError(domain: "Check Internet Connection".localized(), code: nil, userInfo: nil)
            let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : CONSTANT.CHECK_INTERNET_CONNECTION])
            failure(error)
        }
        
    }
    
    func uploadProBImage(_ url: String,imgData:Data, params :[String:String]?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        
        //Optional for extra parameter
        Alamofire.upload(multipartFormData: { multipartFormData in
            
            multipartFormData.append(imgData, withName: "bannerImage",fileName: "bannerImage.jpg", mimeType: "image/jpg")
            
            
            for (key, value) in params! { multipartFormData.append(value.data(using: String.Encoding.utf8)!, withName: key) } //Optional for extraparameters
            
        },
        to:url,method:.post) {
            (result) in switch result { case .success(let upload, _, _): upload.uploadProgress(closure: { (progress) in
                                                                                                print("url",url)
                                                                                                print("parameters",params!)
                                                                                                print("Upload Progress: \(progress.fractionCompleted)") })
                upload.response(completionHandler: { (dataRes) in
                    print(dataRes)
                })
                upload.responseJSON { response in
                    //print("UPLOAD SUCCESS",response.result.value!)
                    let json = String(data: response.data!, encoding: String.Encoding.utf8)
                    print("Failure Response: \(json!)")
                    switch response.result
                    {
                    case .success:
                        if let data = response.data
                        {
                            success(data)
                        }
                    case .failure(let error):
                        failure(error)
                    }
                }
                
            case .failure(let encodingError):
                print(encodingError)
                failure(encodingError)
            } }
    }
    
    func uploadProImage(_ url: String,imgData:Data?, params :[String:Any],headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        Alamofire.upload(multipartFormData: { (multipartFormData) in
               for (key, value) in params {
                   multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
               }
               
               if let data = imgData{
                   multipartFormData.append(data, withName: "image", fileName: "image.jpg", mimeType: "image/jpg")
               }
               
           }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
               switch result{
               case .success(let upload, _, _):
                   upload.responseJSON { response in
                       print("Succesfully uploaded")
                       if let err = response.error{
                        failure(err)
                           return
                       }
                    if let data = response.data
                                            {
                                                success(data)
                                            }
                   }
               case .failure(let error):
                   print("Error in upload: \(error.localizedDescription)")
                failure(error)
               }
           }
       }
        
    }
    
    
    func requestJSON(_ url: String, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
    {
        
        print("URL = ",url)
        
        Alamofire.request(url).responseJSON
        {
            response in
            switch response.result
            {
            case .success:
                if let data = response.data
                {
                    success(data)
                }
            case .failure(let error):
                failure(error)
                break
            }
        }
    //}
    
    
}


func requestGET(_ url: String, params : Parameters?,headers : [String : String]?, success:@escaping (Data) -> Void, failure:@escaping (Error) -> Void)
{
    
    print("URL = ",url)
    print("Parameter = ",params)
    print("Headers = ",headers)
    
    
    if Connectivity.isConnectedToInternet()
    {
        do
        {
            Alamofire.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON
            {
                (response) in
                
                print("Response = ",response)
                
                switch response.result
                {
                case .success:
                    if let data = response.data
                    {
                        success(data)
                    }
                case .failure(let error):
                    failure(error)
                }
            }
        }
        catch let JSONError as NSError
        {
            failure(JSONError)
        }
    }
    else
    {
        //            let err = NSError(domain: "Check Internet Connection".localized(), code: nil, userInfo: nil)
        let error = NSError(domain: "", code: 4, userInfo: [NSLocalizedDescriptionKey : CONSTANT.CHECK_INTERNET_CONNECTION])
        failure(error)
    }
    
}
