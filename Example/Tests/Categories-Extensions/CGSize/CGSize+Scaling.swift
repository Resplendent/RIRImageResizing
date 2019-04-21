//
//  CGSize+Scaling.swift
//  RIRImageResizing_Example
//
//  Created by Benjamin Maer on 4/17/19.
//  Copyright © 2019 Benjamin Maer. All rights reserved.
//

import Foundation
import CoreGraphics

extension CGSize {
    func scaled(scaleWidth: CGFloat = 1, scaleHeight: CGFloat = 1) -> CGSize {
        return CGSize(width: width * scaleWidth, height: self.height * scaleHeight)
    }
    
    func scaled(by scale: CGFloat) -> CGSize {
        return scaled(scaleWidth: scale, scaleHeight: scale)
    }
}
