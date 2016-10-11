//
//  UIImage+RIRImageResizing.h
//  Pods
//
//  Created by Benjamin Maer on 10/7/16.
//
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, UIImage_RIRResizing_ResizeMode) {
	UIImage_RIRResizing_ResizeMode_ScaleToFill,
	UIImage_RIRResizing_ResizeMode_AspectFit,
	UIImage_RIRResizing_ResizeMode_AspectFill,
};





@interface UIImage (RIRImageResizing)

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

#pragma mark - imageHasAlpha
-(BOOL)rir_imageHasAlpha;
+(BOOL)rir_imageHasAlpha:(nonnull CGImageRef)imageRef;

#pragma mark - createARGBBitmapContext
+(nonnull CGContextRef)rir_createARGBBitmapContext:(const size_t)width height:(const size_t)height bytesPerRow:(const size_t)bytesPerRow withAlpha:(BOOL)withAlpha;

@end
