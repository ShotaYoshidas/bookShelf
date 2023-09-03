//
//  SearchBookModel.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/10/06.
//

import Foundation

protocol SearchBookModelDelegate: AnyObject {
    func updateCollectionView()
}

struct TopTier : Codable {
    var kind: String?
    var totalItems: Int?
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


final class TextSearchBookModel {
    weak var delegate: SearchBookModelDelegate? = nil //行き先未定
    private(set) var response: TopTier? = nil {
        didSet {
            //バックグランドに色々処理が動く。それが終わったらDispatchQueueの処理にいく
            DispatchQueue.main.async {
                self.delegate?.updateCollectionView()
            }
        }
    }
    
    func getBooks(encodedString: String) {
        let GoogleBooksAPI = GoogleBooksAPI(keyword: encodedString)
        Task {
            self.response = try await GoogleBooksAPI.getBookData()
        }
    }
    
    func bookIsEmpty() {
       response = nil
        self.delegate?.updateCollectionView()
    }
}
