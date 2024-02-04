//
//  GoogleBooksApiRepository.swift
//  bookShelf
//
//  Created by shota yoshida on 2024/02/04.
//

import Foundation

protocol GoogleBooksApiRepository {
    
    func getBookData() async throws -> Book
    func downloadData(urlString:String) async throws -> Data
}
