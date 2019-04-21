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
        var assertStringComponents: [String] = []
        let startingSize = CGSize(width: 100, height: 100)
        assertStringComponents.append("startingSize: \(startingSize)")
        
        for isHeightLarger in [true, false] {
            var assertStringComponents = assertStringComponents
            let startingSize = CGSize(width: 100, height: 100)
            assertStringComponents.append("isHeightLarger: \(isHeightLarger)")
            for resizeType in RIRImageResizeType.allCases {
                var assertStringComponents = assertStringComponents
                assertStringComponents.append("resizeType".xctAssertComponentFormatted(with: resizeType))
                guard let startingImage = UIImage(size: startingSize) else {
                    XCTFail("Failed to create image with size \(startingSize)".xctAssertFormatted)
                    return
                }
                
                XCTAssert(startingImage.size == startingSize, assertStringComponents.xctAssertFormatted(failureReason: "`startingImage.size` should be equal to `startingSize`", isFinal: true))
                
                assertStringComponents.append("startingImage: \(startingImage)")
                
                let startingWidthToHeightRatio = startingImage.size.height / startingImage.size.width
                assertStringComponents.append("startingWidthToHeightRatio: \(startingWidthToHeightRatio)")
                
                let resizeWidthRatio: CGFloat = 1.0
                let resizeHeightRatio: CGFloat = isHeightLarger ? 1.5 : 0.5
                assertStringComponents.append("resizeWidthRatio: \(resizeWidthRatio)")
                assertStringComponents.append("resizeHeightRatio: \(resizeHeightRatio)")
                
                guard let resizeParameters: RIRResizeImageOperationParameters = {
                    let parametersSize = startingSize.scaled(scaleWidth: resizeWidthRatio, scaleHeight: resizeHeightRatio)
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
                assertStringComponents.append("resizeParameters".xctAssertComponentFormatted(with: resizeParameters))
                
                let resizeWidthToHeightRatio = resizeParameters.newSize.height / resizeParameters.newSize.width
                assertStringComponents.append("resizeWidthToHeightRatio".xctAssertComponentFormatted(with: resizeWidthToHeightRatio))
                
                let operation = startingImage.rirScaledImageOperation(with: resizeParameters)
                guard let resizedImage: UIImage = {
                    do {
                        return try operation.resizedImage()
                    } catch {
                        XCTFail(assertStringComponents.xctAssertFormatted(failureReason: "Failed to create resized image",
                                                                          extraComponents: ["error".xctAssertComponentFormatted(with: error)],
                                                                          isFinal: true))
                        return nil
                    }
                    }()
                    else { return }
                assertStringComponents.append("resizedImage: \(resizedImage)")
                
                let resizedImageWidthToHeightRatio = resizedImage.size.height / resizedImage.size.width
                assertStringComponents.append("resizedImageWidthToHeightRatio".xctAssertComponentFormatted(with: resizedImageWidthToHeightRatio))
                
                if resizeParameters.resizeType.isAspect {
                    let startingImageHeight = startingImage.size.height
                    XCTAssert(startingImageHeight > 0, "`startingImage.size.height` should be non-zero.")
                    let resizedImageHeight = resizedImage.size.height
                    XCTAssert(resizedImageHeight > 0, "`resizedImage.size.height` should be non-zero.")
                    XCTAssert((startingImage.size.width / startingImageHeight) == (resizedImage.size.width / resizedImageHeight),
                              assertStringComponents
                                .xctAssertFormatted(failureReason: "`startingImage.size` should have the same ratio as `resizedImage.size`",
                                                    extraComponents: ["startingImage.size".xctAssertComponentFormatted(with: startingImage.size),
                                                                      "resizedImage.size".xctAssertComponentFormatted(with: resizedImage.size)],
                                                    isFinal: true))
                }
                
                if resizeParameters.allowLargerResizedDimensions == false {
                    XCTAssert(
                        resizedImage.size.width <= startingImage.size.width
                        && resizedImage.size.height <= startingImage.size.height
                        , assertStringComponents.xctAssertFormatted(failureReason: "`resizedImage.size`'s `width` and `height` should be less than `startingImage.size`'s components.",
                                                                    extraComponents: [ "RIRResizeImageOperation(parameters: resizeParameters, image: startingImage).resizedImageSize".xctAssertComponentFormatted(with: operation.resizedImageSize) ],
                                                                    isFinal: true))
                }
                
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
                
                func asserStringComponentsComparisonValues(_ valueNames: ComparisonValues<String> = .comparisonValuesDefault) -> ComparisonValues<String> {
                    return valueNames.map { "`\($0)`" }
                }
                
                func extraAsserStringComponentsComparisonValues<T>(_ valueNames: ComparisonValues<String> = .comparisonValuesDefault, comparisonValues: ComparisonValues<T>) -> ComparisonValues<[String]> {
                    return valueNames.map({ (string, resizeType) -> [String] in
                        return [ string.xctAssertComponentFormatted(with: comparisonValues.value(for: resizeType)) ]
                    })
                }
                
                for comparison in Comparison.allCases {
                    switch comparison {
                    case .resizedImageWidthToHeightRatioAssertion:
                        let comparisonValues = ComparisonValues(scaleToFillValue: isHeightLarger ? startingWidthToHeightRatio : resizeWidthToHeightRatio,
                                                                aspectFitValue: startingWidthToHeightRatio,
                                                                aspectFillValue: startingWidthToHeightRatio)
                        performTest(value: resizedImageWidthToHeightRatio,
                                    comparisonData: ComparisonData(comparisonValues: comparisonValues,
                                                                   asserStringComponents: asserStringComponentsComparisonValues(),
                                                                   sharedAssertStringSuffix: " should be equal to `resizedImageWidthToHeightRatio`",
                                                                   extraAsserStringComponents: extraAsserStringComponentsComparisonValues(comparisonValues: comparisonValues)))
                        
                    case .resizedImageSizeToStartingImageSize:
                        let comparisonValues = ComparisonValues(scaleToFillValue: isHeightLarger ? startingImage.size : startingImage.size.scaled(scaleHeight: resizeHeightRatio),
                                                                aspectFitValue: isHeightLarger ? startingImage.size : startingImage.size.scaled(scaleWidth: resizeHeightRatio, scaleHeight: resizeHeightRatio),
                                                                aspectFillValue: startingImage.size)

                        performTest(value: resizedImage.size,
                                    comparisonData: ComparisonData(comparisonValues: comparisonValues,
                                                                   asserStringComponents: asserStringComponentsComparisonValues(),
                                                                   sharedAssertStringSuffix: " should be equal to `resizedImage.size`",
                                                                   extraAsserStringComponents: extraAsserStringComponentsComparisonValues(comparisonValues: comparisonValues)))

                    case .resizedImageSizeToParametersNewSize:
                        let comparisonValues = ComparisonValues(scaleToFillValue: isHeightLarger ? resizeParameters.newSize.scaled(scaleHeight: 1 / resizeHeightRatio) : resizeParameters.newSize,
                                                                aspectFitValue: isHeightLarger ? resizeParameters.newSize.scaled(scaleHeight: 1 / resizeHeightRatio) : resizeParameters.newSize.scaled(scaleWidth: resizeWidthToHeightRatio),
                                                                aspectFillValue: resizeParameters.newSize.scaled(scaleHeight: 1 / resizeHeightRatio))
                        performTest(value: resizedImage.size,
                                    comparisonData: ComparisonData(comparisonValues: comparisonValues,
                                                                   asserStringComponents: asserStringComponentsComparisonValues(),
                                                                   sharedAssertStringSuffix: " should be equal to `resizedImage.size`",
                                                                   extraAsserStringComponents: extraAsserStringComponentsComparisonValues(comparisonValues: comparisonValues)))
                    }
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

extension Tests_UIImage_RIRImageResizing.ComparisonData {
    typealias ComparisonValues = Tests_UIImage_RIRImageResizing.ComparisonValues
    init(comparisonValues: ComparisonValues<T>, asserStringComponents: ComparisonValues<String>, sharedAssertStringSuffix: String? = nil, extraAsserStringComponents: ComparisonValues<[String]>? = nil) {
        func stringToParam(_ asserStringInitialComponent: String, extraAsserStringComponents: [String]? = nil) -> ([String]) -> [String] {
            return { assertStringComponents in
                return assertStringComponents.xctAssertFormattedComponents(failureReason: {
                    guard let sharedAssertStringSuffix = sharedAssertStringSuffix else { return asserStringInitialComponent }
                    return asserStringInitialComponent + sharedAssertStringSuffix
                }(),
                                                                           extraComponents: extraAsserStringComponents)
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
    
    static let comparisonValuesDefault = ComparisonValues(scaleToFillValue: "comparisonValues.scaleToFillValue",
                                                          aspectFitValue: "comparisonValues.aspectFitValue",
                                                          aspectFillValue: "comparisonValues.aspectFillValue")
}
