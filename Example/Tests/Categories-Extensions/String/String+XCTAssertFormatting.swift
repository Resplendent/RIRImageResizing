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
}

extension Array where Element == String {
    func xctAssertFormatted(isFinal: Bool = true) -> String {
        var string = compactMap {
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
