//
//  BarCodeReaderModel.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/09/23.
//

import Foundation

protocol BarCodeReaderModelDelegate: AnyObject {
    func updateCollectionView()
}
final class BarCodeReaderModel {
    weak var delegate: BarCodeReaderModelDelegate? = nil //行き先未定
    private(set) var books: [Book] = []
    
    func addNewBook(newBook: Book) {
        books.append(newBook)
        
        delegate?.updateCollectionView()
    }
}
