//
//  Tests-CGSize+Scale.swift
//  RIRImageResizing_Tests
//
//  Created by Benjamin Maer on 4/16/19.
//  Copyright © 2019 Benjamin Maer. All rights reserved.
//

import Foundation
import XCTest

@testable import RIRImageResizing

class TestsCGSizeScale: XCTestCase {
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - scaled(to: CGSize)
    func testCGSizeScaleLargerHeight() {
        let startingSize = CGSize(width: 2, height: 3)
        let multiplier: CGFloat = 2.0
        let doubleSize = CGSize(width: startingSize.width * multiplier, height: startingSize.height * multiplier)
        XCTAssert(startingSize.scaled(to: doubleSize) == doubleSize, "Should be equal")
    }
    
    func testCGSizeScaleLargerWidth() {
        let startingSize = CGSize(width: 4, height: 3)
        let scalingSize = CGSize(width: 8, height: 8)
        XCTAssert(startingSize.scaled(to: scalingSize) == CGSize(width: 8, height: 6), "Should be equal")
    }
    
    // MARK: - boundedWithPreservedScale(by: CGSize)
    func testCGSizeScaledAndBoundedLargerWidth() {
        let startingWidth: CGFloat = 20.0
        let startingWidthToHeightRatio: CGFloat = 1.5
        let startingSize = CGSize(width: startingWidth, height: startingWidth * startingWidthToHeightRatio)
        
        let scaledAndBoundedSize = CGSize(width: 10, height: 10)
        
        let finalSize = startingSize.boundedWithPreservedScale(by: scaledAndBoundedSize)
        let finalRatio = finalSize.height / finalSize.width
        
        XCTAssert(finalRatio == startingWidthToHeightRatio,
                  """
            
            `finalRatio` was not equal to `scaledAndBoundedWidthToHeightRatio`
            finalRatio: \(finalRatio)
            startingWidthToHeightRatio: \(startingWidthToHeightRatio)
            startingSize: \(startingSize)
            scaledAndBoundedSize: \(scaledAndBoundedSize)
            finalSize: \(finalSize)
            """)
    }
}
