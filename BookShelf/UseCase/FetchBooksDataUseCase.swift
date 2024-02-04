//
//  SearchBookModel.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/10/06.
//

import Foundation
import UIKit

protocol SearchBookModelDelegate: AnyObject {
    func updateCollectionView()
}
protocol BarCodeReaderModelDelegate: AnyObject {
    func updateCollectionView()
}

// MARK: テキスト検索時の取得データ構造
struct TopTier : Codable {
    var kind: String?
    var totalItems: Int?
    //googleapisで取得結果が10がマストっぽい
    var items: [Item]?
}

struct Item: Codable {
    var volumeInfo: VolumeInfo?
}

struct VolumeInfo: Codable {
    var title: String?
    var authors: [String]?
    var imageLinks: ImageLinks?
}
struct ImageLinks: Codable {
    var thumbnail:String?
}

// MARK: バーコード検索時の取得データ構造
struct Book {
    let title:String
    let author:String
    let thumbnail:UIImage
}

// MARK: 本のデータを取得するユースケース
class FetchBooksDataUseCase {
    private let googleBooksAPI: GoogleBooksApi
    
    init(googleBooksAPI: GoogleBooksApi) {
        self.googleBooksAPI = googleBooksAPI
    }
    
    
    private(set) var books: [Book] = []
    
    func addNewBook(newBook: Book) {
        books.append(newBook)
        barCodeReaderModelDelegate?.updateCollectionView()
    }
    weak var searchBookDelegate: SearchBookModelDelegate? = nil //行き先未定
    weak var barCodeReaderModelDelegate: BarCodeReaderModelDelegate? = nil //行き先未定
    
    //アクセス制限はするが読み取りは可能でprivateよりは制限弱い
    private(set) var response: TopTier? = nil {
        //プロパティ(response)の値が変更された後に呼びたい処理を記述
        didSet {
            //responseに値が全て格納されてからUIの更新を行いたい。このデータ取得の処理の中で一番最後に実行されてた。
            //また、CollectionView.reloadDataの処理がmainスレッドになった。なんで？
            DispatchQueue.main.async {
                if let collectonDelegate = self.searchBookDelegate{
                    collectonDelegate.updateCollectionView()
                    print(self.response?.items?.count)
                    
                }
            }
        }
    }
    
    func fetchBooks(encodedString: String) {
        let googleBooksAPI = GoogleBooksApi(keyword: encodedString)
        //アプリケーションの根源は同期環境から始まるのでasyncなメソッドを呼び出す際にどこかで必ずTaskを使う必要がある。
        Task {
            do {
                //非同期処理が完了すると、その結果が response プロパティに設定される
                self.response = try await googleBooksAPI.getBookData()
                //DispatchQueue.main.asyncでUI更新してgetBooks終了。
            } catch {
                print(error)
            }
        }
    }

    func isbnFetchBooks(isbn:String){
        Task {
            do {
                let newBook = try await googleBooksAPI.getBookData1(isbn: isbn)
                books.append(newBook)
            } catch {
                print(error)
            }
            
            barCodeReaderModelDelegate?.updateCollectionView()
        }
    }
    
    func bookIsEmpty() {
        response = nil
        self.searchBookDelegate?.updateCollectionView()
        }
}
