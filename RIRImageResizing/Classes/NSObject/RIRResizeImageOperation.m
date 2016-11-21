//
//  RIRResizeImageOperation.m
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import "RIRResizeImageOperation.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@interface RIRResizeImageOperation ()

#pragma mark - scale
/**
 Returns a new `UIImage` instance, which is a resized version of the receiver.
 
 @param newSize    The size that the new UIImage instance aims for. This is not necessarily the size of the final image, as it depends on the target image's size, and the `resizeMode` parameter.
 @param resizeMode Indicates which type of resize method to use.
 
 @return A new `UIImage` instance, which is a resized version of the receiver.
 */
-(nullable UIImage*)rir_scaleToSize:(CGSize)newSize usingMode:(UIImage_RIRResizing_ResizeMode)resizeMode;

/**
 Returns a new `UIImage` instance, which is a resized version of the receiver. Uses `UIImage_RIRResizing_ResizeMode_AspectFit` resizing mode.
 
 @param newSize    The size that the new UIImage instance aims for. This is not necessarily the size of the final image, as it depends on the target image's size, and the `resizeMode` parameter.
 
 @return A new `UIImage` instance, which is a resized version of the receiver.
 */
-(nonnull UIImage*)rir_scaleToFitSize:(CGSize)newSize;		//UIImage_RIRResizing_ResizeMode_AspectFit

/**
 Returns a new `UIImage` instance, which is a resized version of the receiver. Uses `UIImage_RIRResizing_ResizeMode_ScaleToFill` resizing mode.
 
 @param newSize    The size that the new UIImage instance aims for. This is not necessarily the size of the final image, as it depends on the target image's size, and the `resizeMode` parameter.
 
 @return A new `UIImage` instance, which is a resized version of the receiver.
 */
-(nonnull UIImage*)rir_scaleToFillSize:(CGSize)newSize;		//UIImage_RIRResizing_ResizeMode_ScaleToFill

/**
 Returns a new `UIImage` instance, which is a resized version of the receiver. Uses `UIImage_RIRResizing_ResizeMode_AspectFill` resizing mode.
 
 @param newSize    The size that the new UIImage instance aims for. This is not necessarily the size of the final image, as it depends on the target image's size, and the `resizeMode` parameter.
 
 @return A new `UIImage` instance, which is a resized version of the receiver.
 */
-(nonnull UIImage*)rir_scaleToCoverSize:(CGSize)newSize;	//UIImage_RIRResizing_ResizeMode_AspectFill

@end





@implementation RIRResizeImageOperation

#pragma mark - NSObject
-(instancetype)init
{
    kRUConditionalReturn_ReturnValueNil(YES, YES);
    return [self init_with_resizeParameters:nil
                                      image:nil];
}

#pragma mark - init
-(instancetype)init_with_resizeParameters:(RIRResizeImageOperationParameters *)resizeParameters
                                    image:(UIImage *)image
{
    kRUConditionalReturn_ReturnValueNil(resizeParameters == nil, NO);
    kRUConditionalReturn_ReturnValueNil(image == nil, NO);
    
    if (self = [super init])
    {
        [self setResizeParameters:resizeParameters];
        [self setImage:image];
    }
}

#pragma mark - scale
-(nullable UIImage*)rir_scaleToSize:(CGSize)newSize usingMode:(UIImage_RIRResizing_ResizeMode)resizeMode
{
    switch (resizeMode)
    {
        case UIImage_RIRResizing_ResizeMode_AspectFit:
            return [self rir_scaleToFitSize:newSize];
            break;
            
        case UIImage_RIRResizing_ResizeMode_AspectFill:
            return [self rir_scaleToCoverSize:newSize];
            break;
            
        case UIImage_RIRResizing_ResizeMode_ScaleToFill:
            return [self rir_scaleToFillSize:newSize];
            break;
            
        default:
            break;
    }
    
    NSAssert(false, @"unhandled %li",(long)resizeMode);
    return nil;
}

-(nonnull UIImage*)rir_scaleToFitSize:(CGSize)newSize
{
    /// Keep aspect ratio
    size_t destWidth, destHeight;
    if (self.image.size.width > self.image.size.height)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.image.size.height * newSize.width / self.image.size.width);
    }
    else
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.image.size.width * newSize.height / self.image.size.height);
    }
    if (destWidth > newSize.width)
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.image.size.height * newSize.width / self.image.size.width);
    }
    if (destHeight > newSize.height)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.image.size.width * newSize.height / self.image.size.height);
    }
    
    return [self rir_scaleToFillSize:(CGSize){
        .width		= destWidth,
        .height		= destHeight,
    }];
}

-(nonnull UIImage*)rir_scaleToFillSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, self.resizeParameters.scale);
    
    [self.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(nonnull UIImage*)rir_scaleToCoverSize:(CGSize)newSize
{
    size_t destWidth, destHeight;
    CGFloat const widthRatio = newSize.width / self.image.size.width;
    CGFloat const heightRatio = newSize.height / self.image.size.height;
    /// Keep aspect ratio
    if (heightRatio > widthRatio)
    {
        destHeight = (size_t)newSize.height;
        destWidth = (size_t)(self.image.size.width * newSize.height / self.image.size.height);
    }
    else
    {
        destWidth = (size_t)newSize.width;
        destHeight = (size_t)(self.image.size.height * newSize.width / self.image.size.width);
    }
    
    return [self rir_scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

#pragma mark - resizedImage
-(UIImage *)resizedImage
{
    return [self rir_scaleToSize:self.resizeParameters.newSize usingMode:self.resizeParameters.resizeMode];
}

@end
