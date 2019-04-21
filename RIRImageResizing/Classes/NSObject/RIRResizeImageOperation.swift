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
    private enum ResizedImagePointer {
        case notSet, attempted, set(UIImage)
    }
    private var resizedImagePointer: ResizedImagePointer = .notSet
    
    enum ResizedImageError: Error {
        case alreadyAttemptedAndFailed
    }
    func resizedImage() throws -> UIImage {
        switch resizedImagePointer {
        case .notSet:
            resizedImagePointer = .attempted
            let resizedImage = try resizedImageGenerate()
            resizedImagePointer = .set(resizedImage)
            return resizedImage
            
        case .attempted:
            throw ResizedImageError.alreadyAttemptedAndFailed
            
        case .set(let image):
            return image
        }
    }
    
    // MARK: - Init
    init(parameters: RIRResizeImageOperationParameters, image: UIImage) {
        self.parameters = parameters
        self.image = image
    }
    
    // MARK: - Resized Image (functions)
    var resizedImageSize: CGSize {
        return {
            switch parameters.resizeType {
            case .scaleToFill:  return resizedImageSizeScaleToFill
            case .aspectFit:    return resizedImageSizeAspectFit
            case .aspectFill:   return resizedImageSizeAspectFill
            }
        }()
    }
    
    private var resizedImageSizeScaleToFill: CGSize {
        return parameters.newSize.bounded(by: image.size)
    }
    
    private var resizedImageSizeAspectFit: CGSize {
        let initialSize = image.size, newSize = parameters.newSize
        var sizeChanges: [(CGSize) -> CGSize] = []
        sizeChanges.append { $0.scaled(to: newSize) }
        sizeChanges.append { $0.boundedWithPreservedScale(by: newSize) }
        sizeChanges.append { $0.boundedWithPreservedScale(by: initialSize) }
        
        var size = initialSize
        sizeChanges.forEach({ sizeFunction in
            size = sizeFunction(size)
        })
        return size
    }
    
    private var resizedImageSizeAspectFill: CGSize {
        let newSize = parameters.newSize
        let widthRatio = newSize.width / image.size.width
        let heightRatio = newSize.height / image.size.height
        let heightRatioIsGreaterThanWidth = heightRatio > widthRatio
        return image.size.boundedWithPreservedScale(by: CGSize(width: heightRatioIsGreaterThanWidth ? image.size.width * heightRatio : newSize.width,
                                                               height: heightRatioIsGreaterThanWidth ? newSize.height : image.size.height * widthRatio))
    }
    
    private func resizedImageGenerate() throws -> UIImage {
        return try resizedImageScaleToFill(size: resizedImageSize)
    }
    
    private func resizedImageScaleToFill() throws -> UIImage {
        return try resizedImageScaleToFill(size: parameters.newSize)
    }
    
    private func resizedImageScaleToFill(size: CGSize) throws -> UIImage {
        return try type(of: self).resized(image: image, scaleToFill: size, scale: scaleToUse)
    }
    
    enum ResizeImageGenerationError: Error {
        case generatedImageWasNil
    }
    private static func resized(image: UIImage, scaleToFill size: CGSize, scale: CGFloat) throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale);
        image.draw(in: CGRect(origin: .zero, size: size))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        guard let finalImage = newImage else {
            throw ResizeImageGenerationError.generatedImageWasNil
        }
        
        return finalImage
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
    @objc func resizedImage() throws -> UIImage {
        return try swiftInstance.resizedImage()
    }
    
    // MARK: - Init
    @objc(init_with_parameters:image:) public init(parameters: RIRResizeImageOperationParametersObjCLegacy, image: UIImage) {
        self.parameters = parameters
        swiftInstance = RIRResizeImageOperation(parameters: parameters.swiftInstance, image: image)
    }
}
