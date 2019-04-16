//
//  RIRImageResizeTypes.swift
//  Pods-RIRImageResizing_Example
//
//  Created by Benjamin Maer on 4/7/19.
//

import Foundation

public enum RIRImageResizeType {
    case scaleToFill, aspectFit, aspectFill
}

@objc(RIRImageResizeType) public enum RIRImageResizeTypeObjCLegacy: Int, CaseIterable {
    case scaleToFill, aspectFit, aspectFill
    
    static let `default`: RIRImageResizeTypeObjCLegacy = .aspectFit
    
    var swiftValue: RIRImageResizeType {
        switch self {
        case .scaleToFill:  return .scaleToFill
        case .aspectFit:    return .aspectFit
        case .aspectFill:   return .aspectFill
        @unknown default:   return RIRImageResizeTypeObjCLegacy.default.swiftValue
        }
    }
}

@objc(RIRImageResizeTypeIteration) public class RIRImageResizeTypeIterationObjCLegacy: NSObject {
    @objc public static let first = RIRImageResizeTypeObjCLegacy.allCases.first!
    @objc public static let last = RIRImageResizeTypeObjCLegacy.allCases.last!
}
