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
                    
                case .aspectFit, .aspectFill:
                    XCTAssert(startingWidthToHeightRatio == resizedImageWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`startingWidthToHeightRatio` should be equal to `resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                }
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
