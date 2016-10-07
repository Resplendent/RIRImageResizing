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
-(nullable UIImage*)rir_scaleToSize:(CGSize)newSize usingMode:(UIImage_RIRResizing_ResizeMode)resizeMode;

-(nonnull UIImage*)rir_scaleToFitSize:(CGSize)newSize;		//UIImage_RIRResizing_ResizeMode_AspectFit
-(nonnull UIImage*)rir_scaleToFillSize:(CGSize)newSize;		//UIImage_RIRResizing_ResizeMode_ScaleToFill
-(nonnull UIImage*)rir_scaleToCoverSize:(CGSize)newSize;	//UIImage_RIRResizing_ResizeMode_AspectFill

#pragma mark - imageHasAlpha
-(BOOL)rir_imageHasAlpha;
+(BOOL)rir_imageHasAlpha:(CGImageRef)imageRef;

#pragma mark - createARGBBitmapContext
+(CGContextRef)rir_createARGBBitmapContext:(const size_t)width height:(const size_t)height bytesPerRow:(const size_t)bytesPerRow withAlpha:(BOOL)withAlpha;

@end
