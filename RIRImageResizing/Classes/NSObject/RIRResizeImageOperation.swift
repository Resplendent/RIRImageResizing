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
    private func resizedImageGenerate() throws -> UIImage {
        switch parameters.resizeType {
        case .scaleToFill:  return try resizedImageScaleToFill()
        case .aspectFit:    return try resizedImageAspectFit()
        case .aspectFill:   return try resizedImageAspectFill()
        }
    }
    
    private func resizedImageScaleToFill() throws -> UIImage {
        return try resizedImageScaleToFill(size: parameters.newSize)
    }
    
    private func resizedImageAspectFit() throws -> UIImage {
        return try resizedImageScaleToFill(size: {
            let initialSize = image.size.scaled(to: parameters.newSize)
            return initialSize.boundedWithPreservedScale(by: parameters.newSize)
//            let boundedToNewSize = initialSize.scaledAndBounded(by: parameters.newSize)
//            return boundedToNewSize.scaledAndBounded(by: image.size)
        }())
    }
    
    private func resizedImageAspectFill() throws -> UIImage {
        let newSize = parameters.newSize
        let widthRatio = newSize.width / image.size.width
        let heightRatio = newSize.height / image.size.height
        let heightRatioIsGreaterThanWidth = heightRatio > widthRatio
        return try resizedImageScaleToFill(size: CGSize(width: heightRatioIsGreaterThanWidth ? image.size.width * heightRatio : newSize.width,
                                                        height: heightRatioIsGreaterThanWidth ? newSize.height : image.size.height * widthRatio))
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
            assertionFailure("""
                Failed to create image with parameters:
                image: \(image)
                size: \(size)
                scale: \(scale)
                """)
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
    @objc var resizedImage: UIImage? {
        do {
            return try swiftInstance.resizedImage()
        } catch {
            assertionFailure("Failed to create resized image with error: \(error)")
            return nil
        }
    }
    
    // MARK: - Init
    @objc(init_with_parameters:image:) public init(parameters: RIRResizeImageOperationParametersObjCLegacy, image: UIImage) {
        self.parameters = parameters
        swiftInstance = RIRResizeImageOperation(parameters: parameters.swiftInstance, image: image)
    }
}
