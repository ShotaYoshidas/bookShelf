//
//  BarCodeReaderModel.swift
//  bookShelf
//
//  Created by shota yoshida on 2022/09/23.
//

import Foundation
import UIKit

protocol BarCodeReaderModelDelegate: AnyObject {
    func updateCollectionView()
}
struct Book {
    let title:String
    let author:String
    let thumbnail:UIImage
}

final class BarCodeReaderModel {
    weak var barCodeReaderModelDelegate: BarCodeReaderModelDelegate? = nil //行き先未定
    private(set) var books: [Book] = []
    
    func addNewBook(newBook: Book) {
        books.append(newBook)
        barCodeReaderModelDelegate?.updateCollectionView()
    }
}
