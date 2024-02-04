//
//  ApiProvider.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/09/23.
//

import Foundation
import SwiftyJSON


//　TODO: 文字列とバーコード検索で共通化する
class GoogleBooksApi:GoogleBooksApiRepository {
    // MARK: isbnでデータ取得
    private let baseURL = "https://api.openbd.jp/v1/get?isbn="
    enum OpenDBAPIError : Error {
        case invalidURLString
        case notFound
    }
//    let isbn:String
//    init(isbn: String) {
//        self.isbn = isbn
//    }
    
    enum GoogleBooksAPIError : Error {
        case invalidURLString
        case notFound
    }
    
    // MARK: 文字列でデータ取得
    // TODO: 名前かえる
    private let baseURL2 = "https://www.googleapis.com/books/v1/volumes?q="
    
    let keyword:String
    init(keyword: String) {
        self.keyword = "\(keyword)"
    }
    
    
    //isbnでデータ取得
    func getBookData1(isbn:String) async throws -> Book {
        let data = try await downloadData(urlString: baseURL + isbn)
        let json = JSON(data)[0]["summary"]
        guard let title = json["title"].string else {
            throw OpenDBAPIError.notFound
        }
        let author = json["author"].string ?? "????"

        // TODO: 何件取得できているか確認する
        if let imageURL = json["cover"].string,
           let image = try? await downloadData(urlString: imageURL){
            return Book(title: title,author: author, thumbnail: UIImage(data: image)!)
        }else{
            return Book(title: title, author: author, thumbnail: UIImage())
        }
    }
    
    func downloadData(urlString:String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw OpenDBAPIError.invalidURLString
        }
        let (data,_) = try await URLSession.shared.data(from: url)
        return data
    }
    
    //非同期関数であることを示すためにasyncを付ける。エラーもthrowできる。
    func getBookData() async throws -> TopTier {
        let data = try await downloadData2(urlString: baseURL + keyword)
        //JSONDecoder=Jsonデータ(データ型)をデコードしてJson文字列にする
        //※デコード(戻す)
        //JSON文字列をTopTierオブジェクトに変換する。仕組みどうなってる？すごい。
        let json = try! JSONDecoder().decode(TopTier.self, from: data)
        
        return TopTier(kind:json.kind, totalItems: json.totalItems, items: json.items)
    }
    
    // TODO: 名前ださい帰る
     func downloadData2(urlString:String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw GoogleBooksAPIError.invalidURLString
        }
        //簡単にネットワーク通信できるやつ。例)https://www.googleapis.com/books/v1/volumes?q=SwiftをURLに打ち込んでる感じ
        let (data,_) = try await URLSession.shared.data(from: url)//Jsonをデータ型で返す。
        //(data,_)＝Data, URLResponseがリターンされる
        return data
    }
    
}

