//
//  RIRResizeImageOperationParameters.m
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import "RIRResizeImageOperationParameters.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation RIRResizeImageOperationParameters

#pragma mark - NSObject
-(instancetype)init
{
    kRUConditionalReturn_ReturnValueNil(YES, YES);
    return [self init_with_newSize:CGSizeZero
                        resizeMode:UIImage_RIRResizing_ResizeMode_AspectFit];
}

#pragma mark - init
-(instancetype)init_with_newSize:(CGSize)newSize
                      resizeMode:(UIImage_RIRResizing_ResizeMode)resizeMode
{
    kRUConditionalReturn_ReturnValueNil(newSize.height < 0 || newSize.width < 0, NO);
    kRUConditionalReturn_ReturnValueNil(resizeMode < UIImage_RIRResizing_ResizeMode_first || resizeMode > UIImage_RIRResizing_ResizeMode_last, NO);
    
    if (self = [super init])
    {
        [self setNewSize:newSize];
        [self setResizeMode:resizeMode];
        [self setScale:0.0f];
    }
    
    return self;
}

@end
