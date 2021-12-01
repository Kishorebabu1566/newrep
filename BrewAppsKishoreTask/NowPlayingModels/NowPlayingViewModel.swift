//
//  NowPlayingViewModel.swift
//  BrewAppsKishoreTask
//
//  Created by Kishore Babu on 30/11/21.
//


import Foundation
import Alamofire

protocol NowPlayingDelegate: class
{
    func didRecieveNowPlaingUpdate(data: NowPlayingData)
    func didFailNowPlayingUpdateWithError(error: Error)
}


class NowPlayingViewModel : NSObject {
    
    weak var delegate: NowPlayingDelegate?
    let sharedInstance = Connection()
    
    
    func nowPlaingApi(){
        
        let url = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
        
//            url = APIList().getUrlStringBusiness(url: .Delete_events)
      
        
//        let parameter : Parameters = [:]
//        let headers: HTTPHeaders = ["Content-Type": "application/json"]
//        sharedInstance.requestPOST(url, params: parameter, headers: headers, success:
        sharedInstance.requestGET(url, params: nil, headers: nil, success:
                                    {
                                        (JSON) in
                                        
                                        let  result :Data? = JSON
                                        
                                        if result != nil
                                        {
                                            do
                {
                    let response = try JSONDecoder().decode(NowPlayingData.self, from: result!)
                    print("the now playing video res is \(response)")
                    DispatchQueue.main.async
                    {
                        self.delegate?.didRecieveNowPlaingUpdate(data: response)
                    }
                }
                                        catch DecodingError.keyNotFound(let key, let context) {
                                            Swift.print("could not find key \(key) in JSON: \(context.debugDescription)")
                                        } catch DecodingError.valueNotFound(let type, let context) {
                                            Swift.print("could not find type \(type) in JSON: \(context.debugDescription)")
                                        } catch DecodingError.typeMismatch(let type, let context) {
                                            Swift.print("type mismatch for type \(type) in JSON: \(context.debugDescription)")
                                        } catch DecodingError.dataCorrupted(let context) {
                                            Swift.print("data found to be corrupted in JSON: \(context.debugDescription)")
                                        } catch let error as NSError {
                                            NSLog("Error in read(from:ofType:) domain= \(error.domain), description= \(error.localizedDescription)")
                                        }
                                        catch let error as NSError
                                        {
                                            self.delegate?.didFailNowPlayingUpdateWithError(error: error)
                                        }
                                    }
                                    else
                                    {
                                        
                                    }
                                    
                                },
                               failure:
                                {
                                    (error) in
                                    self.delegate?.didFailNowPlayingUpdateWithError(error: error)
                                })
    }
}
