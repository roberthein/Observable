import Foundation
import UIKit
import Observable

class Slider: UISlider {
    
    var position = Observable(CGFloat(0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        minimumValue = 0
        maximumValue = 100
        tintColor = UIColor(red: 95/255, green: 20/255, blue: 255/255, alpha: 1)
        addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderValueChanged(_ slider: UISlider) {
        position.value = CGFloat(value / maximumValue)
    }
}
