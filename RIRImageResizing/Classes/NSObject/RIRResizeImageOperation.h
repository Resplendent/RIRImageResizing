//
//  RIRResizeImageOperation.h
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import <Foundation/Foundation.h>

#import "RIRResizeImageOperationParameters.h"





@interface RIRResizeImageOperation : NSObject

#pragma mark - resizeParameters
@property (nonatomic, strong, nullable) RIRResizeImageOperationParameters* resizeParameters;

#pragma mark - image
@property (nonatomic, strong, nullable) UIImage* image;

#pragma mark - init
-(nullable instancetype)init_with_resizeParameters:(RIRResizeImageOperationParameters*)resizeParameters
                                             image:(UIImage*)image;

#pragma mark - resizedImage
-(nonnull UIImage*)resizedImage;


@end
