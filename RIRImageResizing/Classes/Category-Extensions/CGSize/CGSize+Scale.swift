//
//  CGSize+Scale.swift
//  Pods-RIRImageResizing_Example
//
//  Created by Benjamin Maer on 4/15/19.
//

import Foundation

extension CGSize {
    func scaled(to size: CGSize) -> CGSize {
        return width > height
            ? CGSize(width: size.width, height: height * size.width / width)
            : CGSize(width: width * size.height / height, height: size.height)
    }
    
    func scaledAndBounded(by size: CGSize) -> CGSize {
        var scaledAndBoundedSize = self
        
        if scaledAndBoundedSize.width > size.width {
            scaledAndBoundedSize = CGSize(width: size.width, height: scaledAndBoundedSize.height * size.width / scaledAndBoundedSize.width)
        }
        
        if scaledAndBoundedSize.height > size.height {
            scaledAndBoundedSize = CGSize(width: scaledAndBoundedSize.width * size.height / scaledAndBoundedSize.height, height: size.height)
        }
        
        return scaledAndBoundedSize
    }
}
