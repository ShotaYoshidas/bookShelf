//
//  Notification.swift
//  bookShelf
//
//  Created by shota yoshida on 2023/09/03.
//

import Foundation

extension Notification.Name {
    static let addKandokBookShelf = Notification.Name("完読書へ追加")
    static let addTumidokBookShelf = Notification.Name("積読書へ追加")
    static let addBarcodeKandokBookShelf = Notification.Name("完読書へ追加(バーコード)")
    static let addBarcodeTumidokBookShelf = Notification.Name("積読書へ追加(バーコード)")
    static let addManyuaruKandokBookShelf = Notification.Name("積読書へ追加(マニュアル)")
}

