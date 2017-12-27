import UIKit
import Observable

class ViewController: UIViewController {

    private lazy var collectionView = CollectionView()
    private lazy var slider = Slider(frame: .zero)

    private var disposal = Disposal()

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
            slider.heightAnchor.constraint(equalToConstant: 100)
            ])

        collectionView.scrollPercentage.observe { [weak self] percentage, oldValue in
            guard let slider = self?.slider else { return }
            slider.value = percentage * slider.maximumValue
        }.add(to: &disposal)

        slider.position.observe { [weak self] position, oldValue in
            guard let collectionView = self?.collectionView else { return }
            collectionView.contentOffset.x = position * collectionView.contentSize.width - (collectionView.frame.width * position)
        }.add(to: &disposal)
    }
}
