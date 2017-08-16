import UIKit
import Observable

class ViewController: UIViewController {
    
    private lazy var collectionView = CollectionView()
    private lazy var slider = Slider(frame: .zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        view.addSubview(collectionView)
        view.addSubview(slider)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            
            slider.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            slider.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            slider.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            slider.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            slider.heightAnchor.constraint(equalToConstant: 100),
            ])
        
        collectionView.offset.addObserver(self) { offset in
            let percentage = Float((self.collectionView.contentOffset.x / self.collectionView.frame.width) / ((self.collectionView.contentSize.width - self.collectionView.frame.width) / self.collectionView.frame.width))
            let offsetX = percentage * self.slider.maximumValue
            
            self.slider.value = offsetX
        }
        
        slider.offset.addObserver(self) { value in
            let percentage = CGFloat(value / self.slider.maximumValue)
            let offsetX = percentage * self.collectionView.contentSize.width - (self.collectionView.frame.width * percentage)
            
            self.collectionView.contentOffset.x = offsetX
        }
    }
}
