//
//  RIRResizeImageOperationParameters.h
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import "UIImage_RIRResizing_ResizeModes.h"

#import <Foundation/Foundation.h>





@interface RIRResizeImageOperationParameters : NSObject

#pragma mark - newSize
@property (nonatomic, readonly, assign) CGSize newSize;

#pragma mark - resizeMode
@property (nonatomic, readonly, assign) UIImage_RIRResizing_ResizeMode resizeMode;

#pragma mark - scalse
@property (nonatomic, readonly, assign) CGFloat scale;

#pragma mark - init
-(nullable instancetype)init_with_newSize:(CGSize)newSize
                               resizeMode:(UIImage_RIRResizing_ResizeMode)resizeMode
                                    scale:(CGFloat)scale;

@end
