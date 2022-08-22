//
//  PhotoAPIManager.swift
//  DDAK-Network
//
//  Created by taekki on 2022/08/22.
//

import Foundation

import Alamofire
import SwiftyJSON

public class PhotoAPIManager {
    
    public static let shared = PhotoAPIManager()
    
    private init() { }
    
    public typealias completion = ([String]) -> ()
    
    public func searchImage(query: String, page: Int = 1, completion: @escaping completion) {
        guard let query = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = EndPoint.search(query: query, page: page).requestURL
        
        AF.request(url, method: .get).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let data = JSON(value)
                let imageStrings = data["results"].arrayValue.map { $0["urls"]["thumb"].stringValue }
                completion(imageStrings)
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
