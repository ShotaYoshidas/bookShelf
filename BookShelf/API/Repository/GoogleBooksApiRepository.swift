//
//  GoogleBooksApiRepository.swift
//  bookShelf
//
//  Created by shota yoshida on 2024/02/04.
//

import Foundation

protocol GoogleBooksApiRepository {
    
    // バーコード
    func getBookData1(isbn:String) async throws -> Book 
    func downloadData(urlString:String) async throws -> Data
    
    // 文字列
    
    func getBookData() async throws -> TopTier
    func downloadData2(urlString:String) async throws -> Data 
    
}
