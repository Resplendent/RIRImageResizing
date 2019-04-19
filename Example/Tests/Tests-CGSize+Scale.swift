//
//  Tests-CGSize+Scale.swift
//  RIRImageResizing_Tests
//
//  Created by Benjamin Maer on 4/16/19.
//  Copyright © 2019 Benjamin Maer. All rights reserved.
//

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
        for multiplier in (1...10) {
            let multipliedSize = startingSize.scaled(by: CGFloat(multiplier))
            let finalSize = startingSize.scaled(to: multipliedSize)
            XCTAssert(finalSize == multipliedSize,[
                "`finalSize` should be equal to `multipliedSize`",
                "startingSize: \(startingSize)",
                "multiplier: \(multiplier)",
                "multipliedSize: \(multipliedSize)",
                "finalSize: \(finalSize)"
                ].xctAssertFormatted)
        }
    }
    
    func testCGSizeScaleLargerWidth() {
        let startingSize = CGSize(width: 4, height: 3)
        for multiplier in (1...10) {
            let multiplier = CGFloat(multiplier)
            let scalingSize = CGSize(width: startingSize.width * multiplier, height: startingSize.width * multiplier)
            let finalSize = startingSize.scaled(to: scalingSize)
            let compareToSize = startingSize.scaled(by: multiplier)
            
            XCTAssert(finalSize == compareToSize,[
                "`finalSize` should be equal to `compareToSize`",
                "startingSize: \(startingSize)",
                "multiplier: \(multiplier)",
                "scalingSize: \(scalingSize)",
                "finalSize: \(finalSize)",
                "compareToSize: \(compareToSize)"
                ].xctAssertFormatted)
        }
    }
    
    // MARK: - boundedWithPreservedScale(by: CGSize)
    func testCGSizeScaledAndBoundedLargerWidth() {
        let scaledAndBoundedSize = CGSize(width: 10, height: 10)
        let scaledAndBoundedWidthToHeightRatio = scaledAndBoundedSize.height / scaledAndBoundedSize.width
        
        let startingWidth: CGFloat = scaledAndBoundedSize.width
        
        let increment: CGFloat = 0.25
        for startingWidthToHeightRatio in stride(from: increment, to: 3.0, by: increment) {
            let startingSize = CGSize(width: startingWidth, height: startingWidth * startingWidthToHeightRatio)
            
            let finalSize = startingSize.boundedWithPreservedScale(by: scaledAndBoundedSize)
            let finalRatio = finalSize.height / finalSize.width
            
            let ratioToCompareTo = startingWidthToHeightRatio
            
            var assertString: String {
                return [
                    "scaledAndBoundedSize: \(scaledAndBoundedSize)",
                    "scaledAndBoundedWidthToHeightRatio: \(scaledAndBoundedWidthToHeightRatio)",
                    "startingWidthToHeightRatio: \(startingWidthToHeightRatio)",
                    "startingSize: \(startingSize)",
                    "finalSize: \(finalSize)",
                    "finalRatio: \(finalRatio)",
                ].xctAssertFormatted(isFinal: false)
            }
            
            XCTAssert(finalRatio == ratioToCompareTo, [
                "`finalRatio` should be equal to `ratioToCompareTo`",
                assertString,
                "ratioToCompareTo: \(ratioToCompareTo)",
                ].xctAssertFormatted)
            
            let sizeToCompareTo = startingWidthToHeightRatio < 1.0
                ? CGSize(width: scaledAndBoundedSize.width, height: scaledAndBoundedSize.width * startingWidthToHeightRatio)
                : CGSize(width: startingSize.width / startingWidthToHeightRatio, height: scaledAndBoundedSize.height)
            
            XCTAssert(finalSize == sizeToCompareTo, [
                "`finalSize` should be equal to `sizeToCompareTo`",
                assertString,
                "sizeToCompareTo: \(sizeToCompareTo)",
                ].xctAssertFormatted)
        }
    }
}
