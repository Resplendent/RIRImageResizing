//
//  RIRResizeImageOperation.h
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import "RIRResizeImageOperationParameters.h"

#import <Foundation/Foundation.h>





@interface RIRResizeImageOperation : NSObject

#pragma mark - resizeParameters
@property (nonatomic, readonly, strong, nullable) RIRResizeImageOperationParameters* resizeParameters;

#pragma mark - image
@property (nonatomic, readonly, strong, nullable) UIImage* image;

#pragma mark - init
-(nullable instancetype)init_with_resizeParameters:(nullable RIRResizeImageOperationParameters*)resizeParameters
                                             image:(nullable UIImage*)image;

#pragma mark - resizedImage
@property (nonatomic, readonly, strong, nullable) UIImage* resizedImage;

@end
