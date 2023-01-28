//
//  GoogleBooksAPI2.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/10/08.
//

import Foundation
import SwiftyJSON

class GoogleBooksAPI2 {
    enum GoogleBooksAPIError : Error {
        case invalidURLString
        case notFound
    }
    
    private let baseURL = "https://www.googleapis.com/books/v1/volumes?q="
    let keyword:String
    init(keyword: String) {
        self.keyword = "\(keyword)"
    }
    
    func getBookData() async throws -> TopTier {
        let data = try await downloadData(urlString: baseURL + keyword)
        let jsonString = String(data: data, encoding: .utf8)!
        let json = try! JSONDecoder().decode(TopTier.self, from: jsonString.data(using: .utf8)!)
        return TopTier(kind:json.kind, totalItems: json.totalItems, items: json.items)
    }
    
    final func downloadData(urlString:String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw GoogleBooksAPIError.invalidURLString
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        return data
    }
    
    
    
    
}
