//
//  AspectRatioImageView.swift
//  CleanList
//
//  Created by Vasiliy Fedotov on 27.03.2021.
//

import UIKit

class AspectRatioImageView: UIImageView {

    let aspectRatioConstraintIdentifier = "logoAspectRatio"

    override open var image: UIImage? {
        didSet {

            guard let img = image else {
                removeOldConstraint()
                return
            }
            
            let height = img.size.height * img.scale
            let width = img.size.width * img.scale
            
            setAspectRatio(CGFloat(height)/CGFloat(width))
        }
    }
    
    func setAspectRatio(_ aspectRatio: CGFloat) {

        removeOldConstraint()
        
        let aspectRatioConstraint = NSLayoutConstraint(item: self, attribute: .height,
                                                       relatedBy: .equal,
                                                       toItem: self, attribute: .width,
                                                       multiplier: aspectRatio,
                                                       constant: 0)
        aspectRatioConstraint.identifier = aspectRatioConstraintIdentifier
        
//        addConstraint(aspectRatioConstraint)
    }
    
    private func removeOldConstraint() {
        let oldConstraints = constraints.filter { $0.identifier == aspectRatioConstraintIdentifier }
        NSLayoutConstraint.deactivate(oldConstraints)
    }

}
