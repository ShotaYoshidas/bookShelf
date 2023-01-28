//
//  ApiProvider.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/09/23.
//

import Foundation
import SwiftyJSON

class APIProvider {
    private let baseURL = "https://api.openbd.jp/v1/get?isbn="
    enum OpenDBAPIError : Error {
        case invalidURLString
        case notFound
    }
    let isbn:String
    init(isbn: String) {
        self.isbn = isbn
    }
    
    func getBookData() async throws -> Book {
        let data = try await downloadData(urlString: baseURL + isbn)
        let json = JSON(data)[0]["summary"]
        guard let title = json["title"].string else {
            throw OpenDBAPIError.notFound
        }
        let pubdate = json["pubdate"].string ?? "????????"
        let author = json["author"].string ?? "????"
        if let imageURL = json["cover"].string,
           let image = try? await downloadData(urlString: imageURL){
            return Book(title: title, publishDate: pubdate, author: author, thumbnail: UIImage(data: image)!)
        }else{
            print("画像ない")
            return Book(title: title, publishDate: pubdate, author: author, thumbnail: UIImage())
        }
    }
    
    final func downloadData(urlString:String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw OpenDBAPIError.invalidURLString
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        return data
    }
}

