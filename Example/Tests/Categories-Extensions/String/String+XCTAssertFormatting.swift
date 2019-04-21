//
//  String+XCTAssertFormatting.swift
//  RIRImageResizing_Example
//
//  Created by Benjamin Maer on 4/16/19.
//  Copyright © 2019 Benjamin Maer. All rights reserved.
//

import Foundation

extension String {
    var xctAssertFormatted: String { return "\n" + self }
    
    // MARK: - Component
    func xctAssertComponentFormatted(with value: Any) -> String {
        return self + ": " + String(describing: value)
    }
}

extension Array where Element == String {
    // MARK: - Formatted Components
    func xctAssertFormattedComponents(failureReason: String? = nil, extraComponents: [String]? = nil) -> [String] {
        //    func xctAssertFormatted(isFinal: Bool = true) -> String {
        var assertStringComponents = self
        if let failureReason = failureReason {
            assertStringComponents.insert(failureReason, at: 0)
        }
        
        if let extraComponents = extraComponents {
            assertStringComponents.append(contentsOf: extraComponents)
        }
        
        return assertStringComponents
    }
    
    // MARK: - Formatted
    func xctAssertFormatted(failureReason: String? = nil, extraComponents: [String]? = nil, isFinal: Bool = true) -> String {
        var string = xctAssertFormattedComponents(failureReason: failureReason, extraComponents: extraComponents).compactMap {
            guard $0.isEmpty == false else {
                assertionFailure("Shouldn't pass in empty components")
                return nil
            }
            
            return $0
            }
            .joined(separator: "\n")
        
        if isFinal {
            string = string.xctAssertFormatted
        }
        
        return string
    }
    
    var xctAssertFormatted: String { return xctAssertFormatted() }
}
