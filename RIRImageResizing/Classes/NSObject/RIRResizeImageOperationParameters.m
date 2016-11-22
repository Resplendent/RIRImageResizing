//
//  RIRResizeImageOperationParameters.m
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import "RIRResizeImageOperationParameters.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@interface RIRResizeImageOperationParameters ()

#pragma mark - newSize
@property (nonatomic, assign) CGSize newSize;

#pragma mark - resizeMode
@property (nonatomic, assign) UIImage_RIRResizing_ResizeMode resizeMode;

#pragma mark - scalse
@property (nonatomic, assign) CGFloat scale;

@end





@implementation RIRResizeImageOperationParameters

#pragma mark - NSObject
-(instancetype)init
{
    kRUConditionalReturn_ReturnValueNil(YES, YES);
    return [self init_with_newSize:CGSizeZero
                        resizeMode:UIImage_RIRResizing_ResizeMode_none
                             scale:0.0f];
}

#pragma mark - init
-(instancetype)init_with_newSize:(CGSize)newSize
                      resizeMode:(UIImage_RIRResizing_ResizeMode)resizeMode
                           scale:(CGFloat)scale
{
    kRUConditionalReturn_ReturnValueNil(newSize.height <= 0 || newSize.width <= 0, YES);
    kRUConditionalReturn_ReturnValueNil(UIImage_RIRResizing_ResizeMode__isInRange(resizeMode) == NO, YES);
    
    if (self = [super init])
    {
        [self setNewSize:newSize];
        [self setResizeMode:resizeMode];
        [self setScale:scale];
    }
    
    return self;
}

@end
