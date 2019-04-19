//
//  UIImage+RIRImageResizing.swift
//  Pods-RIRImageResizing_Example
//
//  Created by Benjamin Maer on 4/15/19.
//

import Foundation

extension UIImage {
    func rirScaledImageOperation(with parameters: RIRResizeImageOperationParameters) -> RIRResizeImageOperation {
        return RIRResizeImageOperation(parameters: parameters, image: self)
    }
    
    func rirScaledImage(with parameters: RIRResizeImageOperationParameters) throws -> UIImage {
        return try rirScaledImageOperation(with: parameters).resizedImage()
    }
}

@objc public extension UIImage {
    @objc(rir_scaledImageOperation_with_parameters:) func rirScaledImageOperationObjCLegacy(with parameters: RIRResizeImageOperationParametersObjCLegacy) -> RIRResizeImageOperationObjCLegacy {
        return RIRResizeImageOperationObjCLegacy(parameters: parameters, image: self)
    }
    
    @objc(rir_scaledImage_with_parameters:) func rirScaledImageObjCLegacy(with parameters: RIRResizeImageOperationParametersObjCLegacy) -> UIImage? {
        return rirScaledImageOperationObjCLegacy(with: parameters).resizedImage
    }
}
