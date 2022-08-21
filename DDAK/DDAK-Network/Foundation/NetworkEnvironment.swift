//
//  NetworkEnvironment.swift
//  DDAK-Network
//
//  Created by taekki on 2022/08/22.
//

import Foundation

enum NetworkEnvironment {
    
    static var unsplashBaseURL: String {
        return "https://api.unsplash.com"
    }
    
    static func makeEndPointString(_ endPoint: String) -> String {
        return unsplashBaseURL + endPoint
    }
}
