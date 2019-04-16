//
//  RIRResizeImageOperation.swift
//  Pods-RIRImageResizing_Example
//
//  Created by Benjamin Maer on 4/7/19.
//

import Foundation
import UIKit

public class RIRResizeImageOperation {
    // MARK: - Parameters
    let parameters: RIRResizeImageOperationParameters
    
    // MARK: - Image
    let image: UIImage
    
    // MARK: - Has Attempted Image Resize
    private var hasAttemptedImageResize: Bool = false
    
    // MARK: - Resized Image
    private var resizedImagePointer: UIImage?
    var resizedImage: UIImage? {
        if resizedImagePointer == nil {
            guard hasAttemptedImageResize == false else {
                assertionFailure("`resizedImagePointer` is nil, but we've already attempted to resize the image.")
                return nil
            }
            
            hasAttemptedImageResize = true
            
            resizedImagePointer = resizedImageGenerate
        }
        
        return resizedImagePointer
    }
    
    // MARK: - Init
    init(parameters: RIRResizeImageOperationParameters, image: UIImage) {
        self.parameters = parameters
        self.image = image
    }
    
    // MARK: - Resized Image (functions)
    private var resizedImageGenerate: UIImage? {
        switch parameters.resizeType {
        case .scaleToFill:  return resizedImageScaleToFill
        case .aspectFit:    return resizedImageAspectFit
        case .aspectFill:   return resizedImageAspectFill
        }
    }
    
    private var resizedImageScaleToFill: UIImage? {
        return resizedImageScaleToFill(size: parameters.newSize)
    }
    
    private var resizedImageAspectFit: UIImage? {
        return resizedImageScaleToFill(size: {
            let initialSize = image.size.scaled(to: parameters.newSize)
            return initialSize.scaledAndBounded(by: parameters.newSize)
//            let boundedToNewSize = initialSize.scaledAndBounded(by: parameters.newSize)
//            return boundedToNewSize.scaledAndBounded(by: image.size)
        }())
    }
    
    private var resizedImageAspectFill: UIImage? {
        let newSize = parameters.newSize
        let widthRatio = newSize.width / image.size.width
        let heightRatio = newSize.height / image.size.height
        let heightRatioIsGreaterThanWidth = heightRatio > widthRatio
        return resizedImageScaleToFill(size: CGSize(width: heightRatioIsGreaterThanWidth ? image.size.width * heightRatio : newSize.width,
                                                    height: heightRatioIsGreaterThanWidth ? newSize.height : image.size.height * widthRatio))
    }
    
    private func resizedImageScaleToFill(size: CGSize) -> UIImage? {
        return type(of: self).resized(image: image, scaleToFill: size, scale: scaleToUse)
    }
    
    private static func resized(image: UIImage, scaleToFill size: CGSize, scale: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale);
        image.draw(in: CGRect(origin: .zero, size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    // MARK: - Scale
    private var scaleToUse: CGFloat {
        guard
            let scale = parameters.scale,
            scale > 0
            else { return image.scale }
        return scale
    }
}

@objc(RIRResizeImageOperation) public class RIRResizeImageOperationObjCLegacy: NSObject {
    // MARK: - Parameters
    @objc let parameters: RIRResizeImageOperationParametersObjCLegacy
    
    // MARK: - Image
    @objc var image: UIImage { return swiftInstance.image }
    
    // MARK: - Swift Instance
    let swiftInstance: RIRResizeImageOperation
    
    // MARK: - Resized Image
    @objc var resizedImage: UIImage? { return swiftInstance.resizedImage }
    
    // MARK: - Init
    @objc(init_with_parameters:image:) public init(parameters: RIRResizeImageOperationParametersObjCLegacy, image: UIImage) {
        self.parameters = parameters
        swiftInstance = RIRResizeImageOperation(parameters: parameters.swiftInstance, image: image)
    }
}
