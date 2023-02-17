import UIKit

struct Pokemon: Equatable {
let name: String
let imageName: String
}
class CustumCollectionViewCell: UICollectionViewCell {
lazy var textLabel = UILabel()
required init(coder aDecoder: NSCoder) {
super.init(coder: aDecoder)!
    }
override init(frame: CGRect) {
super.init(frame: frame)
        backgroundColor = .white
        textLabel = UILabel(frame: CGRect(x: 0, y: frame.height-20, width: frame.width, height: 20))
        textLabel.backgroundColor = UIColor.black
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.textColor = UIColor.white
        contentView.addSubview(textLabel)
    }
func setCell(name: String, imageName: String) {
        textLabel.text = name
let image = UIImage(named: imageName)
        backgroundView = UIImageView(image: image)
    }
}
class aViewController: UIViewController {
var pokemons: [Pokemon] = [
Pokemon(name: "Snorlax", imageName: "bookImage"),
Pokemon(name: "Diglett", imageName: "bookImage"),
Pokemon(name: "Quagsire", imageName: "bookImage"),
Pokemon(name: "Slowpoke", imageName: "bookImage"),
Pokemon(name: "Ditto", imageName: "bookImage"),
Pokemon(name: "Eevee", imageName: "bookImage"),
Pokemon(name: "Meowth", imageName: "bookImage"),
Pokemon(name: "Oddish", imageName: "bookImage"),
Pokemon(name: "Paras", imageName: "bookImage"),
    ]
var collectionView : UICollectionView!
override func viewDidLoad() {
super.viewDidLoad()
let viewWidth = view.frame.width
let viewHeight = view.frame.height
        let layout = UICollectionViewFlowLayout()
// cell size
        layout.itemSize = CGSize(width:viewWidth/4, height:viewWidth/4)
// cell margin
        layout.sectionInset = UIEdgeInsets.zero
// cell vertical margin
        layout.minimumInteritemSpacing = 0.0
// cell horizontal margin
        layout.minimumLineSpacing = 0.0
// section header size
        layout.headerReferenceSize = CGSize(width: 0, height: 0)
// CollectionView
        let collectionFrame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: layout)
// register cell class
        collectionView.register(CustumCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(CustumCollectionViewCell.self))
        collectionView.delegate = self
        collectionView.dataSource = self
        view.addSubview(collectionView)
let longTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTap(gesture:)))
        collectionView.addGestureRecognizer(longTapGesture)
    }
@objc func longTap(gesture: UILongPressGestureRecognizer) {
switch gesture.state {
case .began:
guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
break
            }
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
case .ended:
            collectionView.endInteractiveMovement()
default:
            collectionView.cancelInteractiveMovement()
        }
    }
}
extension aViewController: UICollectionViewDelegate, UICollectionViewDataSource {
func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
print("yos:\(pokemons[indexPath.row])")
    }
func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
return pokemons.count
    }
func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
let cell : CustumCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(CustumCollectionViewCell.self), for: indexPath) as! CustumCollectionViewCell
let pokemon = pokemons[indexPath.row]
        cell.setCell(name: pokemon.name, imageName: pokemon.imageName)
return cell
    }
func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    print("yosi\(pokemons.remove(at: sourceIndexPath.row))")
let item = pokemons.remove(at: sourceIndexPath.row)
        pokemons.insert(item, at: destinationIndexPath.row)
    print("yosi\(pokemons.insert(item, at: destinationIndexPath.row))")
    }
func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
return true
    }
}
