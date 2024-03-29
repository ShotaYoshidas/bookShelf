
import Foundation
import RealmSwift

class BookObject: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = ""
    @objc dynamic var author: String = ""
    @objc dynamic var imageData: Data = Data()
    @objc dynamic var memo: String = ""
    @objc dynamic var saveTime: String = ""
    @objc dynamic var readKey: Int = 0
}

let nillImage: UIImage = UIImage(named:"bookImage")!.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)

final class BookShelfModel {
    private(set) var books: Results<BookObject>
    private(set) var roadBooks: Results<BookObject>
    private(set) var willBooks: Results<BookObject>
    
    init() {
        let realm = try! Realm()
        books = realm.objects(BookObject.self)
        roadBooks = realm.objects(BookObject.self).filter("readKey == 0 ")
        willBooks = realm.objects(BookObject.self).filter("readKey == 1 ")
    }
    
    func SerchKandokuUpdate(newBook1: Item) {
        if let url = URL(string: newBook1.volumeInfo?.imageLinks?.thumbnail! ?? "") {
            let fileData = try! Data(contentsOf: url)
            let realm = try! Realm()
            let object: BookObject = {
                let object = BookObject()
                object.title = newBook1.volumeInfo?.title ?? ""
                object.author = newBook1.volumeInfo?.authors?[0] ?? ""
                object.imageData = fileData
                object.saveTime = getNowClockString()
                object.readKey = 0
                return object
            }()
            try! realm.write() {
                realm.add(object)
            }
        } else {
            let realm = try! Realm()
            let object: BookObject = {
                let object = BookObject()
                object.title = newBook1.volumeInfo?.title ?? ""
                object.author = newBook1.volumeInfo?.authors?[0] ?? ""
                object.imageData = nillImage.pngData() ?? Data()
                object.saveTime = getNowClockString()
                object.readKey = 0
                return object
            }()
            try! realm.write() {
                realm.add(object)
            }
        }
        NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
        
    }
    
    func SerchTumidokuUpdate(newBook2: Item) {
        if let url = URL(string: newBook2.volumeInfo?.imageLinks?.thumbnail! ?? "") {
            let fileData = try! Data(contentsOf: url)
            let realm = try! Realm()
            let object: BookObject = {
                let object = BookObject()
                object.title = newBook2.volumeInfo?.title ?? ""
                object.author = newBook2.volumeInfo?.authors?[0] ?? ""
                object.imageData = fileData
                object.saveTime = getNowClockString()
                object.readKey = 1
                return object
            }()
            try! realm.write() {
                realm.add(object)
            }
        } else {
            let realm = try! Realm()
            let object: BookObject = {
                let object = BookObject()
                object.title = newBook2.volumeInfo?.title ?? ""
                object.author = newBook2.volumeInfo?.authors?[0] ?? ""
                object.imageData = nillImage.pngData() ?? Data()
                object.saveTime = getNowClockString()
                object.readKey = 1
                return object
            }()
            try! realm.write() {
                realm.add(object)
            }
        }
        
        NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
        }
        
    func BarcodeKandokuUpdate(newBook3: Book) {
        let realm = try! Realm()
        if (realm.objects(BookObject.self).filter({ $0.title == newBook3.title && $0.author == newBook3.author}).first != nil){
        } else  {
            let object: BookObject = {
                let object = BookObject()
                object.title = newBook3.title
                object.author = newBook3.author
                object.imageData = newBook3.thumbnail.pngData() ?? Data()
                object.saveTime = getNowClockString()
                object.readKey = 0
                //pngDataはデータ型(BookObjectは画像保存できない為),uiimage→pngdata(nillになり失敗する可能性がある為、その時は??以降のやつ使用してください。)
                //pngDataはオプショナルデータ
                return object
            }()
            try! realm.write() {
                realm.add(object)
            }
            NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
        }
    }
    
    func BarcodeTumidokuUpdate(newBook4: Book) {
        let realm = try! Realm()
        if (realm.objects(BookObject.self).filter({ $0.title == newBook4.title && $0.author == newBook4.author}).first != nil){
        } else  {
            let object: BookObject = {
                let object = BookObject()
                object.title = newBook4.title
                object.author = newBook4.author
                object.imageData = newBook4.thumbnail.pngData() ?? Data()
                object.saveTime = getNowClockString()
                object.readKey = 1
                return object
            }()
            try! realm.write() {
                realm.add(object)
            }
            NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
        }
    }

    func addNewBook3(title:String,author:String,thumnail:UIImage) {
        let realm = try! Realm()
        let object: BookObject = {
            let object = BookObject()
            object.title = title
            object.author = author
            object.imageData = thumnail.pngData() ?? Data()
            object.saveTime = getNowClockString()
            object.readKey = 0
            return object
        }()
        try! realm.write() {
            realm.add(object)
        }
        NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
    }
    
    func updateText(memo: String, id: String) {
        
        let realm = try! Realm()
        guard let upDateText = realm.objects(BookObject.self).filter({ $0.id == id }).compactMap({ $0 }).first else { return }
        do {
            try realm.write{
                upDateText.memo = memo
            }
        } catch {
            print("Error \(error)")
        }
    }
    
    func deleteBook(id: String) {
        let realm = try! Realm()
        let deleteBook = realm.objects(BookObject.self).filter({ $0.id == id })
        do{
            try realm.write{
                realm.delete(deleteBook)
            }
        }catch {
            print("Error \(error)")
        }
        NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
    }
    
    func dateSort() {
        let realm = try! Realm()
            roadBooks = realm.objects(BookObject.self).filter("readKey == 0").sorted(byKeyPath: "saveTime", ascending: true)
            willBooks = realm.objects(BookObject.self).filter("readKey == 1").sorted(byKeyPath: "saveTime", ascending: true)
            try! realm.write() {
                realm.add(roadBooks)
                realm.add(willBooks)
            }
            NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
    }
    
    func dateRsort() {
        let realm = try! Realm()
            roadBooks = realm.objects(BookObject.self).filter("readKey == 0").sorted(byKeyPath: "saveTime", ascending: false)
            willBooks = realm.objects(BookObject.self).filter("readKey == 1").sorted(byKeyPath: "saveTime", ascending: false)
            try! realm.write() {
                realm.add(roadBooks)
                realm.add(willBooks)
            }
            NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
    }

    func moveBook(id: String) {
        let realm = try! Realm()
        guard let temp = realm.objects(BookObject.self).filter({ $0.id == id }).compactMap({ $0 }).first else { return }
        do {
            try realm.write{
                if temp.readKey == 0 {
                    temp.readKey = 1
                } else {
                    temp.readKey = 0
                }
            }
        } catch {
            print("Error \(error)")
        }
        NotificationCenter.default.post(name: .reloadBookShelf, object: nil)
    }
    
    func getNowClockString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd' 'HH:mm:ss"
        let now = Date()
        return formatter.string(from: now)
    }
    
}
