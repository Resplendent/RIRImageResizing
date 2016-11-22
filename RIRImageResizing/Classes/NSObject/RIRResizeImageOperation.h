//
//  RIRResizeImageOperation.h
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import <Foundation/Foundation.h>





@class RIRResizeImageOperationParameters;





@interface RIRResizeImageOperation : NSObject

#pragma mark - init
-(nullable instancetype)init_with_resizeParameters:(nonnull RIRResizeImageOperationParameters*)resizeParameters
                                             image:(nonnull UIImage*)image;

#pragma mark - resizedImage
@property (nonatomic, readonly, strong, nullable) UIImage* resizedImage;

@end
