//
//  RIRResizeImageOperationParameters.swift
//  Pods-RIRImageResizing
//
//  Created by Benjamin Maer on 4/7/19.
//

import Foundation

public class RIRResizeImageOperationParameters {
    let newSize: CGSize
    let resizeType: RIRImageResizeType
    let scale: CGFloat?
    
    // MARK: - Init
    enum InitError: Error {
        case badNewSizeWidth, badNewSizeHeight
    }
    
    init(newSize: CGSize, resizeType: RIRImageResizeType, scale: CGFloat? = 0) throws {
        guard newSize.width > 0 else    { throw InitError.badNewSizeWidth }
        guard newSize.height > 0 else   { throw InitError.badNewSizeHeight }
        
        self.newSize = newSize
        self.resizeType = resizeType
        self.scale = scale
    }
}

@objc(RIRResizeImageOperationParameters) public class RIRResizeImageOperationParametersObjCLegacy: NSObject {
    @objc var newSize: CGSize { return swiftInstance.newSize }
    @objc let resizeType: RIRImageResizeTypeObjCLegacy
    @objc var scale: CGFloat { return swiftInstance.scale ?? 0 }
    
    // MARK: - Swift Instance
    let swiftInstance: RIRResizeImageOperationParameters
    
    // MARK: - Init
    @objc(init_with_newSize:resizeMode:scale:) public init?(newSize: CGSize, resizeType: RIRImageResizeTypeObjCLegacy, scale: CGFloat = 0) {
        self.resizeType = resizeType
        do {
            try swiftInstance = RIRResizeImageOperationParameters(newSize: newSize, resizeType: resizeType.swiftValue, scale: scale)
        } catch {
            assertionFailure("Failed to create `swiftParameters`")
            return nil
        }
    }
}
