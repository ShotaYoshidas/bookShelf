//
//  GoogleBooksAPI2.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/10/08.
//

import Foundation
//SwiftyJSON不使用

class GoogleBooksAPI {
    enum GoogleBooksAPIError : Error {
        case invalidURLString
        case notFound
    }
    
    private let baseURL = "https://www.googleapis.com/books/v1/volumes?q="
    let keyword:String
    init(keyword: String) {
        self.keyword = "\(keyword)"
    }
    
    //非同期関数であることを示すためにasyncを付ける。エラーもthrowできる。
    func getBookData() async throws -> TopTier {
        let data = try await downloadData(urlString: baseURL + keyword)
        //JSONDecoder=Jsonデータ(データ型)をデコードしてJson文字列にする
        //※デコード(戻す)
        //JSON文字列をTopTierオブジェクトに変換する。仕組みどうなってる？すごい。
        let json = try! JSONDecoder().decode(TopTier.self, from: data)
        
        return TopTier(kind:json.kind, totalItems: json.totalItems, items: json.items)
    }
    
    final func downloadData(urlString:String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw GoogleBooksAPIError.invalidURLString
        }   
        //簡単にネットワーク通信できるやつ。例)https://www.googleapis.com/books/v1/volumes?q=SwiftをURLに打ち込んでる感じ
        let (data,_) = try await URLSession.shared.data(from: url)//Jsonをデータ型で返す。
        //(data,_)＝Data, URLResponseがリターンされる
        return data
    }
}
