import Foundation
import UIKit
import Observable

class CollectionView: UICollectionView {
    
    var offset = Observable(CGPoint.zero)
    
    convenience init() {
        let size = (UIScreen.main.bounds.width / 2) - 30
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: size, height: size)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        
        self.init(frame: .zero, collectionViewLayout: layout)
        
        register(UICollectionViewCell.self, forCellWithReuseIdentifier: "CellReuseIdentifier")
        translatesAutoresizingMaskIntoConstraints = false
        dataSource = self
        delegate = self
        contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 40, right: 0)
        backgroundColor = nil
        clipsToBounds = false
        showsHorizontalScrollIndicator = false
    }
}

extension CollectionView: UICollectionViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offset.value = scrollView.contentOffset
    }
}

extension CollectionView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellReuseIdentifier", for: indexPath)
        cell.backgroundColor = .gray
        cell.layer.cornerRadius = 10
        cell.clipsToBounds = false
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 30
    }
}
