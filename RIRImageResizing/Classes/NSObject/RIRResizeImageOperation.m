//
//  RIRResizeImageOperation.m
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import "RIRResizeImageOperation.h"
#import "RIRResizeImageOperationParameters.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@interface RIRResizeImageOperation ()

#pragma mark - scale
/**
 Returns a new `UIImage` instance, which is a resized version of the receiver.
 
 @param newSize    The size that the new UIImage instance aims for. This is not necessarily the size of the final image, as it depends on the target image's size, and the `resizeMode` parameter.
 @param resizeMode Indicates which type of resize method to use.
 
 @return A new `UIImage` instance, which is a resized version of the receiver.
 */
-(nullable UIImage*)scaleToSize:(CGSize)newSize usingMode:(UIImage_RIRResizing_ResizeMode)resizeMode;

/**
 Returns a new `UIImage` instance, which is a resized version of the receiver. Uses `UIImage_RIRResizing_ResizeMode_aspectFit` resizing mode.
 
 @param newSize    The size that the new UIImage instance aims for. This is not necessarily the size of the final image, as it depends on the target image's size, and the `resizeMode` parameter.
 
 @return A new `UIImage` instance, which is a resized version of the receiver.
 */
-(nonnull UIImage*)scaleToFitSize:(CGSize)newSize;		//UIImage_RIRResizing_ResizeMode_aspectFit

/**
 Returns a new `UIImage` instance, which is a resized version of the receiver. Uses `UIImage_RIRResizing_ResizeMode_scaleToFill` resizing mode.
 
 @param newSize    The size that the new UIImage instance aims for. This is not necessarily the size of the final image, as it depends on the target image's size, and the `resizeMode` parameter.
 
 @return A new `UIImage` instance, which is a resized version of the receiver.
 */
-(nonnull UIImage*)scaleToFillSize:(CGSize)newSize;		//UIImage_RIRResizing_ResizeMode_scaleToFill

/**
 Returns a new `UIImage` instance, which is a resized version of the receiver. Uses `UIImage_RIRResizing_ResizeMode_aspectFill` resizing mode.
 
 @param newSize    The size that the new UIImage instance aims for. This is not necessarily the size of the final image, as it depends on the target image's size, and the `resizeMode` parameter.
 
 @return A new `UIImage` instance, which is a resized version of the receiver.
 */
-(nonnull UIImage*)scaleToCoverSize:(CGSize)newSize;	//UIImage_RIRResizing_ResizeMode_aspectFill

#pragma mark - resizeParameters
@property (nonatomic, strong, nonnull) RIRResizeImageOperationParameters* resizeParameters;

#pragma mark - image
@property (nonatomic, strong, nonnull) UIImage* image;


@end





@implementation RIRResizeImageOperation

#pragma mark - NSObject
-(instancetype)init
{
    kRUConditionalReturn_ReturnValueNil(YES, YES);
    return [self init_with_resizeParameters:[RIRResizeImageOperationParameters new]
                                      image:[UIImage new]];
}

#pragma mark - init
-(instancetype)init_with_resizeParameters:(nonnull RIRResizeImageOperationParameters *)resizeParameters
                                    image:(nonnull UIImage *)image
{
    kRUConditionalReturn_ReturnValueNil(resizeParameters == nil, YES);
    kRUConditionalReturn_ReturnValueNil(image == nil, YES);
    
    if (self = [super init])
    {
        [self setResizeParameters:resizeParameters];
        [self setImage:image];
    }
    
    return self;
}

#pragma mark - scale
-(nullable UIImage*)scaleToSize:(CGSize)newSize usingMode:(UIImage_RIRResizing_ResizeMode)resizeMode
{
    switch (resizeMode)
    {
        case UIImage_RIRResizing_ResizeMode_aspectFit:
            return [self scaleToFitSize:newSize];
            break;
            
        case UIImage_RIRResizing_ResizeMode_aspectFill:
            return [self scaleToCoverSize:newSize];
            break;
            
        case UIImage_RIRResizing_ResizeMode_scaleToFill:
            return [self scaleToFillSize:newSize];
            break;
            
        default:
            break;
    }
    
    NSAssert(false, @"unhandled %li",(long)resizeMode);
    return nil;
}

-(nonnull UIImage*)scaleToFitSize:(CGSize)newSize
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
    
    return [self scaleToFillSize:(CGSize){
        .width		= destWidth,
        .height		= destHeight,
    }];
}

-(nonnull UIImage*)scaleToFillSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, self.resizeParameters.scale);
    
    [self.image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(nonnull UIImage*)scaleToCoverSize:(CGSize)newSize
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
    
    return [self scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

#pragma mark - resizedImage
@synthesize resizedImage = _resizedImage;

-(nullable UIImage *)resizedImage
{
    if (_resizedImage == nil)
    {
        _resizedImage = [self scaleToSize:self.resizeParameters.newSize usingMode:self.resizeParameters.resizeMode];
    }
    return _resizedImage;
}

@end
