//
//  CallSlider.swift
//  EmergencyPreparednessApp
//
//  Created by Jubin Jose on 2017-10-16.
//  Copyright © 2017 IBM. All rights reserved.
//

import UIKit

protocol CallSliderDelegate:class {
    func didMakeCall(sender: CallSlider)
}

@IBDesignable

class CallSlider: UISlider {

    @IBInspectable open var trackWidth: CGFloat = 2 {
        didSet {setNeedsDisplay()}
    }
    var titleLabel: UILabel?
    weak var delegate: CallSliderDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //loadTitleLabel()
    }
    
    override func awakeFromNib() {
        self.isContinuous = false
        self.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        //loadTitleLabel()
        for state: UIControl.State in [.normal, .selected, .application, .reserved] {
            self.setThumbImage(UIImage(named: "phone"), for: state)
        }

        self.minimumTrackTintColor = UIColor.red
        self.maximumTrackTintColor = UIColor.red
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func sliderValueChanged(sender: CallSlider?) {
        
        if let theSender = sender{
            if theSender.value == 1.0{
                if let delegate = delegate{
                    delegate.didMakeCall(sender: self)
                }
            }
            theSender.setValue(0.0, animated: true)
        }
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let defaultBounds = super.trackRect(forBounds: bounds)
        return CGRect(
            x: defaultBounds.origin.x,
            y: defaultBounds.origin.y + defaultBounds.size.height/2 - trackWidth/2,
            width: defaultBounds.size.width,
            height: trackWidth
        )
    }
    
    private func loadTitleLabel(){
        titleLabel = UILabel(frame: self.trackRect(forBounds: self.bounds))
        titleLabel?.textColor = UIColor.white
        titleLabel?.textAlignment = .center
        titleLabel?.text = "Dial 911"
        self.addSubview(titleLabel!)
       // self.bringSubview(toFront: titleLabel!)
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        loadTitleLabel()
    }
    

}
