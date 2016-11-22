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

#pragma mark - init
-(nullable instancetype)init_with_newSize:(CGSize)newSize
                               resizeMode:(UIImage_RIRResizing_ResizeMode)resizeMode
                                    scale:(CGFloat)scale;

@end
