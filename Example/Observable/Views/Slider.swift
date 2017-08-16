import Foundation
import UIKit
import Observable

class Slider: UISlider {
    
    var offset = Observable(Float(0))
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        minimumValue = 0
        maximumValue = 100
        addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func sliderValueChanged(_ slider: UISlider) {
        offset.value = slider.value
    }
}
