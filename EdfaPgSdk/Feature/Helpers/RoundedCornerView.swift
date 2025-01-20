//
//  Untitled.swift
//  Pods
//
//  Created by Haseebburiro on 17/10/2024.
//

import UIKit

@IBDesignable
class RoundedCornerView: UIView {

    
    @IBInspectable var cornerRadius: CGFloat = 0.0 {
            didSet {
                updateCorners()
            }
        }

        // You can set specific corners (only bottom left in this case)
        private func updateCorners() {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [.bottomLeft], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }

        override func layoutSubviews() {
            super.layoutSubviews()
            updateCorners()
        }
}
