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

final class SearchBookModel {
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
        let GoogleAPI = GoogleBooksAPI2(keyword: encodedString)
        Task {
            self.response = try await GoogleAPI.getBookData()
        }
    }
    
    func bookIsEmpty() {
       response = nil
        self.delegate?.updateCollectionView()
    }
}
