//
//  Tests-UIImage+RIRImageResizing.swift
//  RIRImageResizing_Tests
//
//  Created by Benjamin Maer on 4/17/19.
//  Copyright © 2019 Benjamin Maer. All rights reserved.
//

import XCTest

@testable import RIRImageResizing

class Tests_UIImage_RIRImageResizing: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }
    
    // MARK: - rirScaledImage(with: CGSize)
    func testScaledImage() {
        for isLarger in [true, false] {
            let assertStringComponents = ["isLarger: \(isLarger)"]
            for resizeType in RIRImageResizeType.allCases {
                var assertStringComponents = assertStringComponents
                assertStringComponents.append("resizeType: \(resizeType)")
                let startingSize = CGSize(width: 100, height: 100)
                assertStringComponents.append("startingSize: \(startingSize)")
                guard let startingImage = UIImage(size: startingSize) else {
                    XCTFail("Failed to create image with size \(startingSize)".xctAssertFormatted)
                    return
                }
                
                assertStringComponents.append("startingImage: \(startingImage)")
                
                let startingWidthToHeightRatio = startingImage.size.height / startingImage.size.width
                assertStringComponents.append("startingWidthToHeightRatio: \(startingWidthToHeightRatio)")
                
                let resizeWidthRatio: CGFloat = 1.0
                let resizeHeightRatio: CGFloat = isLarger ? 1.5 : 0.5
                assertStringComponents.append("resizeWidthRatio: \(resizeWidthRatio)")
                assertStringComponents.append("resizeHeightRatio: \(resizeHeightRatio)")
                
                guard let resizeParameters: RIRResizeImageOperationParameters = {
                    let parametersSize = CGSize(width: startingSize.width * resizeWidthRatio, height: startingSize.height * resizeHeightRatio)
                    do {
                        return try RIRResizeImageOperationParameters(newSize: parametersSize,
                                                                     resizeType: resizeType)
                    } catch {
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("Failed to create operation parameters", at: 0)
                        assertStringComponents.append("parametersSize: \(parametersSize)")
                        assertStringComponents.append("error: \(error)")
                        XCTFail(assertStringComponents.xctAssertFormatted)
                        return nil
                    }
                    }()
                    else { return }
                assertStringComponents.append("resizeParameters: \(String(describing: resizeParameters))")
                
                let resizeWidthToHeightRatio = resizeParameters.newSize.height / resizeParameters.newSize.width
                assertStringComponents.append("resizeWidthToHeightRatio: \(resizeWidthToHeightRatio)")
                
                guard let resizedImage: UIImage = {
                    do {
                        return try startingImage.rirScaledImage(with: resizeParameters)
                    } catch {
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("Failed to create resized image", at: 0)
                        assertStringComponents.append("error: \(error)")
                        XCTFail(assertStringComponents.xctAssertFormatted)
                        return nil
                    }
                    }()
                    else { return }
                assertStringComponents.append("resizedImage: \(resizedImage)")
                
                let resizedImageWidthToHeightRatio = resizedImage.size.height / resizedImage.size.width
                assertStringComponents.append("resizedImageWidthToHeightRatio: \(resizedImageWidthToHeightRatio)")
                
                switch resizeType {
                case .scaleToFill:
                    XCTAssert(resizeWidthToHeightRatio == resizedImageWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`resizeWidthToHeightRatio` should be equal to `resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(resizedImage.size == resizeParameters.newSize, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`resizedImage.size` should be equal to `resizeParameters.newSize`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(resizedImage.size.width * resizeWidthToHeightRatio == resizedImage.size.height, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`resizedImage.size.width * resizeWidthToHeightRatio` should be equal to `resizedImage.size.height`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(startingImage.size.width == resizedImage.size.width, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`startingImage.size.width` should be equal to `resizedImage.size.width`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(startingImage.size.height * resizeWidthToHeightRatio == resizedImage.size.height, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`startingImage.size.height * resizeWidthToHeightRatio` should be equal to `resizedImage.size.height`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                case .aspectFit:
                    XCTAssert(startingWidthToHeightRatio == resizedImageWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`startingWidthToHeightRatio` should be equal to `resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(resizedImage.size.height == resizeParameters.newSize.height, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`resizedImage.size.height` should be equal to `resizeParameters.newSize.height`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(resizedImage.size.width == resizeParameters.newSize.width * resizeWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`resizedImage.size.width` should be equal to `resizeParameters.newSize.width * resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(startingImage.size.width == resizeParameters.newSize.width * resizeWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`startingImage.size.width` should be equal to `resizeParameters.newSize.width * resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                
                case .aspectFill:
                    XCTAssert(startingWidthToHeightRatio == resizedImageWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`startingWidthToHeightRatio` should be equal to `resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(resizedImage.size.height == resizeParameters.newSize.height, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`resizedImage.size.height` should be equal to `resizeParameters.newSize.height`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(resizedImage.size.width == resizeParameters.newSize.width * resizeWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`resizedImage.size.width` should be equal to `resizeParameters.newSize.width * resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                    XCTAssert(startingImage.size.width == resizeParameters.newSize.width * resizeWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`startingImage.size.width` should be equal to `resizeParameters.newSize.width * resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                }
                
//                print(assertStringComponents.xctAssertFormatted)
            }
        }
    }
}

private extension UIImage {
    convenience init?(size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 1.0)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}
