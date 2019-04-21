//
//  RIRResizeImageOperationParameters.swift
//  Pods-RIRImageResizing
//
//  Created by Benjamin Maer on 4/7/19.
//

import Foundation

public class RIRResizeImageOperationParameters {
    // MARK: - Constants
    public struct PublicConstants {
        public static let allowLargerResizedDimensionsDefaultValue = RIRResizeImageOperationParametersObjCLegacy.allowLargerResizedDimensionsDefaultValue
    }
    
    let newSize: CGSize
    let resizeType: RIRImageResizeType
    let scale: CGFloat?
    
    let allowLargerResizedDimensions: Bool
    
    // MARK: - Init
    enum InitError: Error {
        case badNewSizeWidth, badNewSizeHeight
    }
    
    public init(newSize: CGSize,
                resizeType: RIRImageResizeType,
                scale: CGFloat? = 0,
                allowLargerResizedDimensions: Bool = PublicConstants.allowLargerResizedDimensionsDefaultValue) throws {
        guard newSize.width > 0 else    { throw InitError.badNewSizeWidth }
        guard newSize.height > 0 else   { throw InitError.badNewSizeHeight }
        
        self.newSize = newSize
        self.resizeType = resizeType
        self.scale = scale
        self.allowLargerResizedDimensions = allowLargerResizedDimensions
    }
}

extension RIRResizeImageOperationParameters: CustomStringConvertible {
    public var description: String {
        return [
            "newSize: \(newSize)",
            "resizeType: \(resizeType)",
            "scale: \(String(describing: scale))",
        ].joined(separator: "\n")
    }
}

@objc(RIRResizeImageOperationParameters) public class RIRResizeImageOperationParametersObjCLegacy: NSObject {
    // MARK: - Constants
    @objc public static let allowLargerResizedDimensionsDefaultValue = false
    
    @objc var newSize: CGSize { return swiftInstance.newSize }
    @objc let resizeType: RIRImageResizeTypeObjCLegacy
    @objc var scale: CGFloat { return swiftInstance.scale ?? 0 }
    @objc var allowLargerResizedDimensions: Bool { return swiftInstance.allowLargerResizedDimensions }
    
    // MARK: - Swift Instance
    let swiftInstance: RIRResizeImageOperationParameters
    
    // MARK: - Init
    @objc(init_with_newSize:resizeMode:scale:allowLargerResizedDimensions:) public init?(newSize: CGSize, resizeType: RIRImageResizeTypeObjCLegacy, scale: CGFloat = 0, allowLargerResizedDimensions: Bool) {
        self.resizeType = resizeType
        do {
            try swiftInstance = RIRResizeImageOperationParameters(newSize: newSize, resizeType: resizeType.swiftValue, scale: scale, allowLargerResizedDimensions: allowLargerResizedDimensions)
        } catch {
            assertionFailure("Failed to create `swiftParameters`")
            return nil
        }
    }
    
    @objc(init_with_newSize:resizeMode:scale:) public convenience init?(newSize: CGSize, resizeType: RIRImageResizeTypeObjCLegacy, scale: CGFloat = 0) {
        self.init(newSize: newSize, resizeType: resizeType, scale: scale, allowLargerResizedDimensions: RIRResizeImageOperationParametersObjCLegacy.allowLargerResizedDimensionsDefaultValue)
    }
}
