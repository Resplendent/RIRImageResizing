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
    fileprivate struct ComparisonValues<T> {
        let scaleToFillValue: T
        let aspectFitValue: T
        let aspectFillValue: T
        
        func value(for type: RIRImageResizeType) -> T {
            switch type {
            case .scaleToFill:  return scaleToFillValue
            case .aspectFit:    return aspectFitValue
            case .aspectFill:   return aspectFillValue
            }
        }
    }
    
    fileprivate struct ComparisonData<T> {
        let comparisonValues: ComparisonValues<T>
        let asserStringComponents: ComparisonValues<([String]) -> [String]>
    }
    
    func testScaledImage() {
        for isHeightLarger in [true, false] {
            let assertStringComponents = ["isHeightLarger: \(isHeightLarger)"]
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
                let resizeHeightRatio: CGFloat = isHeightLarger ? 1.5 : 0.5
                assertStringComponents.append("resizeWidthRatio: \(resizeWidthRatio)")
                assertStringComponents.append("resizeHeightRatio: \(resizeHeightRatio)")
                
                guard let resizeParameters: RIRResizeImageOperationParameters = {
                    let parametersSize = startingSize.scaled(scaleWidth: resizeWidthRatio, height: resizeHeightRatio)
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
                
                func performTest<T: Equatable>(value: T, comparisonData: ComparisonData<T>, file: StaticString = #file, line: UInt = #line) {
                    let valueToCompareTo = comparisonData.comparisonValues.value(for: resizeType)
                    let assertStringComponentsClosure = comparisonData.asserStringComponents.value(for: resizeType)
                    XCTAssert(value == valueToCompareTo, assertStringComponentsClosure(assertStringComponents).xctAssertFormatted, file: file, line: line)
                }
                
                enum Comparison: CaseIterable {
                    case resizedImageWidthToHeightRatioAssertion
                    case resizedImageSizeToStartingImageSize
                    case resizedImageSizeToParametersNewSize
                }
                
                let valueNamesDefault = ComparisonValues(scaleToFillValue: "comparisonValues.scaleToFillValue",
                                                         aspectFitValue: "comparisonValues.aspectFitValue",
                                                         aspectFillValue: "comparisonValues.aspectFillValue")
                func asserStringComponentsComparisonValues(_ valueNames: ComparisonValues<String> = valueNamesDefault) -> ComparisonValues<String> {
                    return valueNames.map { "`\($0)`" }
                }
                
                func extraAsserStringComponentsComparisonValues<T>(_ valueNames: ComparisonValues<String> = valueNamesDefault, comparisonValues: ComparisonValues<T>) -> ComparisonValues<[String]> {
                    return valueNames.map({ (string, resizeType) -> [String] in
                        return [ string.xctAssertComponentFormatted(with: comparisonValues.value(for: resizeType)) ]
                    })
                }
                
                for comparison in Comparison.allCases {
                    switch comparison {
                    case .resizedImageWidthToHeightRatioAssertion:
                        performTest(value: resizedImageWidthToHeightRatio,
                                    comparisonData: ComparisonData(comparisonValues: ComparisonValues(scaleToFillValue: resizeWidthToHeightRatio,
                                                                                                      aspectFitValue: startingWidthToHeightRatio,
                                                                                                      aspectFillValue: startingWidthToHeightRatio),
                                                                   asserStringComponents: ComparisonValues(scaleToFillValue: "`resizeWidthToHeightRatio`",
                                                                                                           aspectFitValue: "`startingWidthToHeightRatio`",
                                                                                                           aspectFillValue: "`startingWidthToHeightRatio`"),
                                                                   sharedAssertStringSuffix: " should be equal to `resizeWidthToHeightRatio`"))
                        
                    case .resizedImageSizeToStartingImageSize:
                        let comparisonValues = ComparisonValues(scaleToFillValue: startingImage.size,
                                                                aspectFitValue: isHeightLarger ? startingImage.size : startingImage.size.scaled(scaleWidth: resizeWidthToHeightRatio),
                                                                aspectFillValue: isHeightLarger ? startingImage.size.scaled(scaleWidth: resizeWidthToHeightRatio) : startingImage.size)
                        performTest(value: resizedImage.size,
                                    comparisonData: ComparisonData(comparisonValues: comparisonValues,
                                                                   asserStringComponents: asserStringComponentsComparisonValues(),
                                                                   sharedAssertStringSuffix: " should be equal to `resizedImage.size`",
                                                                   extraAsserStringComponents: extraAsserStringComponentsComparisonValues(comparisonValues: comparisonValues)))
                        
                    case .resizedImageSizeToParametersNewSize:
                        let comparisonValues = ComparisonValues(scaleToFillValue: resizeParameters.newSize,
                                                                aspectFitValue: isHeightLarger ? resizeParameters.newSize : resizeParameters.newSize.scaled(scaleWidth: resizeWidthToHeightRatio),
                                                                aspectFillValue: isHeightLarger ? resizeParameters.newSize.scaled(scaleWidth: resizeWidthToHeightRatio) : resizeParameters.newSize)
                        performTest(value: resizedImage.size,
                                    comparisonData: ComparisonData(comparisonValues: comparisonValues,
                                                                   asserStringComponents: asserStringComponentsComparisonValues(),
                                                                   sharedAssertStringSuffix: " should be equal to `resizedImage.size`",
                                                                   extraAsserStringComponents: extraAsserStringComponentsComparisonValues(comparisonValues: comparisonValues)))
                    }
                }
                
                switch resizeType {
                case .scaleToFill:
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
                    XCTAssert(startingImage.size.width == resizeParameters.newSize.width * resizeWidthToHeightRatio, { () -> [String] in
                        var assertStringComponents = assertStringComponents
                        assertStringComponents.insert("`startingImage.size.width` should be equal to `resizeParameters.newSize.width * resizeWidthToHeightRatio`", at: 0)
                        return assertStringComponents
                        }().xctAssertFormatted)
                    
                case .aspectFill:
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

extension Tests_UIImage_RIRImageResizing.ComparisonData {
    typealias ComparisonValues = Tests_UIImage_RIRImageResizing.ComparisonValues
    init(comparisonValues: ComparisonValues<T>, asserStringComponents: ComparisonValues<String>, sharedAssertStringSuffix: String? = nil, extraAsserStringComponents: ComparisonValues<[String]>? = nil) {
        func stringToParam(_ asserStringInitialComponent: String, extraAsserStringComponents: [String]? = nil) -> ([String]) -> [String] {
            return { assertStringComponents in
                var assertStringComponents = assertStringComponents
                assertStringComponents.insert({
                    guard let sharedAssertStringSuffix = sharedAssertStringSuffix else { return asserStringInitialComponent }
                    return asserStringInitialComponent + sharedAssertStringSuffix
                }(), at: 0)
                if let extraAsserStringComponents = extraAsserStringComponents {
                    assertStringComponents.append(contentsOf: extraAsserStringComponents)
                }
                return assertStringComponents
            }
        }
        
        
        self.init(comparisonValues: comparisonValues,
                  asserStringComponents: .init(scaleToFillValue: stringToParam(asserStringComponents.scaleToFillValue, extraAsserStringComponents: extraAsserStringComponents?.scaleToFillValue),
                                               aspectFitValue: stringToParam(asserStringComponents.aspectFitValue, extraAsserStringComponents: extraAsserStringComponents?.aspectFitValue),
                                               aspectFillValue: stringToParam(asserStringComponents.aspectFillValue, extraAsserStringComponents: extraAsserStringComponents?.aspectFillValue)))
    }
}

private typealias ComparisonValues = Tests_UIImage_RIRImageResizing.ComparisonValues
extension ComparisonValues where T == String {
    func map<R>(_ mapClosure: (T, RIRImageResizeType) -> R) -> ComparisonValues<R> {
        return ComparisonValues(scaleToFillValue: mapClosure(scaleToFillValue, .scaleToFill),
                                aspectFitValue: mapClosure(aspectFitValue, .aspectFit),
                                aspectFillValue: mapClosure(aspectFillValue, .aspectFill))
    }
    
    func map<R>(_ mapClosure: (T) -> R) -> ComparisonValues<R> {
        return map { (string, _) in return mapClosure(string) }
    }
}
