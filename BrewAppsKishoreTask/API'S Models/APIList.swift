//
//  APIList.swift
//  BrewAppsKishoreTask
//
//  Created by Kishore Babu on 30/11/21.
//

import Foundation

struct APIList
{
    let playingURL = "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let trailersURL = "https://api.themoviedb.org/3/movie/209112/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let imageURL = "https://image.tmdb.org/t/p/original"

    func getPlayingUrlString(url: urlString) -> String
    {
        return playingURL + url.rawValue
    }
    func getTrailerString(url: urlString) -> String
    {
        return trailersURL + url.rawValue
    }
//    func getImageString(url: String)
//    {
//        return imageURL + url.rawValue
//    }
    
}


enum urlString: String
{
    
    case LOGIN = "login"
    case LOGOUT = "log_out"
    case nightMode = "NIGHT_MODE"

}
