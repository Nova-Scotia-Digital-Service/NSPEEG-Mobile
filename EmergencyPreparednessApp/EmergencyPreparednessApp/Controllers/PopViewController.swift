//
//  PopViewController.swift
//  EmergencyPreparednessApp
//
//  Created by Parlad Dhungana on 2018-12-06.
//  Copyright © 2018 IBM. All rights reserved.
//

import UIKit

class PopViewController: UIViewController, UIGestureRecognizerDelegate
{
    //MARK: - Properties and iboutlets
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
    }
    
    var popup: Popup!{
        didSet{
            startAnimation()
            iconImage.image = popup.image ?? UIImage()
            definitionTitle.text = popup.title ?? ""
            descriptionLabel.text = popup.description ?? ""
        }
    }
    
    @IBOutlet weak var popView: UIView!{
        didSet{
            popView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            popView.alpha = 0
            popView.layer.cornerRadius = 8
            popView.clipsToBounds = true
            popView.layer.borderColor = UIColor.darkGray.cgColor
            popView.layer.borderWidth = 0.5
        }
    }
    
   
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var definitionTitle: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
   
    @IBAction func exitPopUp(_ sender: Any) {
        stopAnimation()
    }
    
    private func startAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.popView.transform = .identity
            self.popView.alpha = 1
        })
    }
    
    private func stopAnimation(){
        UIView.animate(withDuration: 0.2, delay: 0, options: .transitionCrossDissolve, animations: {
            self.popView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self.popView.alpha = 0
        }, completion: { finished in
            if finished {
                self.view.removeFromSuperview()
                self.removeFromParent()
            }
           
        })
    }
    
    private func setupTapGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
        tap.delegate = self
    }
    
    @objc private func handleTap(){
        stopAnimation()
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        guard let toucView = touch.view?.isDescendant(of: popView) else {return false}
        if toucView {
            return false
        }
        return true
    }
    
    deinit {
        print("Popup deallocated")
    }
}
