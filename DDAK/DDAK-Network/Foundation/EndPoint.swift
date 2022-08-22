//
//  EndPoint.swift
//  DDAK-Network
//
//  Created by taekki on 2022/08/22.
//

import Foundation

enum EndPoint {
    case search(query: String, page: Int, perPage: Int)
    case random(count: Int)
    
    var requestURL: String {
        switch self {
        case .search(let query, let page, let perPage):
            return NetworkEnvironment.makeEndPointString("/search/photos?client_id=\(APIKeys.unsplash)&query=\(query)&page=\(page)&per_page=\(perPage)")
            
        case .random(let count):
            return NetworkEnvironment.makeEndPointString("/photos/random?client_id=\(APIKeys.unsplash)&count=\(count)")
        }
    }
}
