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
    func scaled(by scale: CGFloat) -> CGSize {
        return CGSize(width: width * scale, height: height * scale)
    }
}
