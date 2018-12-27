//
//  ViewController.swift
//  label_with_text_animation
//
//  Created by Danni on 12/26/18.
//  Copyright © 2018 Danni Chen. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    
    var initialValueForLabel = 10000
  
    
//  use closure to map images to views that hold label on the top half and image on bottom half
    lazy var viewsHoldingImageAndLabel:[UIView] = {
        
        let images = [#imageLiteral(resourceName: "cry"),#imageLiteral(resourceName: "angry"),#imageLiteral(resourceName: "cry_laugh")]
        let imageViews = images.map({ (image) -> UIView in
            let bigView = UIView()
            //              add label to bigView
            let label = UILabel()
            label.font = .boldSystemFont(ofSize: 30)
            label.textColor = .blue
            label.text = String(initialValueForLabel)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            bigView.addSubview(label)
//            set anchors
            label.topAnchor.constraint(equalTo: bigView.topAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: bigView.leadingAnchor).isActive = true
            label.trailingAnchor.constraint(equalTo: bigView.trailingAnchor).isActive  = true
            label.heightAnchor.constraint(equalTo: bigView.heightAnchor, multiplier: 0.5).isActive = true
            
//          add imageView to big view
            
            let imageView = UIImageView(image: image)
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            bigView.addSubview(imageView)
//            set anchors
            imageView.leadingAnchor.constraint(equalTo: bigView.leadingAnchor).isActive = true
            imageView.trailingAnchor.constraint(equalTo: bigView.trailingAnchor).isActive = true
            imageView.topAnchor.constraint(equalTo: label.bottomAnchor).isActive = true
            imageView.bottomAnchor.constraint(equalTo: bigView.bottomAnchor, constant: -50).isActive = true
            
            //  imageView.bottomAnchor.constraint(equalTo: bigView.bottomAnchor).isActive = true
            return bigView
            
        })
        return imageViews
    }()
    
//  stackView holding each subViews(viewsHoldingImageAndLabel)
    lazy var stackView:UIStackView = {
        let stackView = UIStackView(arrangedSubviews: viewsHoldingImageAndLabel)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        return stackView
    }()
    
  
    override func viewDidLoad() {
   
        let viewFrame = view.safeAreaLayoutGuide.layoutFrame
        super.viewDidLoad()
        view.addSubview(stackView)
        stackView.frame = viewFrame
//      create displayLink
        let displayLink = CADisplayLink(target: self, selector: #selector(handleAnimation))
        displayLink.add(to:.main, forMode: .default)

        
//      start animation
        for i in stackView.arrangedSubviews.indices{
            print("first")
            let bigView = stackView.arrangedSubviews[i]
            if let imageView = bigView.subviews[1] as? UIImageView{
                 bigView.animationZoomInAndRoatate(imageView: imageView)
            }
        }

        
      
    }
//  function to accumulate number and reflects on label
    @objc private func handleAnimation(){
        
        if initialValueForLabel != 10500{
            for i in stackView.arrangedSubviews.indices{
                let bigView = stackView.arrangedSubviews[i]
                if let label = bigView.subviews.first as? UILabel{
                  
                    label.text = String(initialValueForLabel*(i+1))
                }
            }
            initialValueForLabel+=1
        }
    }
}

//  extension of animations
extension UIView{
    
    private func animationZoomOut(imageView:UIView){
        
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1.8, initialSpringVelocity: 1.8, options: .curveEaseIn, animations: {
            imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            
        }, completion: {(_) in
            imageView.transform = CGAffineTransform.identity
        })
    }
    
    func animationZoomInAndRoatate(imageView:UIView){
        UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1.8, initialSpringVelocity: 1.8, options: .curveEaseIn, animations: {
            imageView.transform = CGAffineTransform(scaleX: 2, y: 2).rotated(by: -CGFloat.pi)
        }, completion: {(_) in
            UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: 1.8, initialSpringVelocity: 1.8, options: .curveEaseOut, animations: {
                imageView.transform = CGAffineTransform.identity
            }, completion: {(_) in
                    self.animationZoomOut(imageView: imageView)
            })
        })
    }
    
}

