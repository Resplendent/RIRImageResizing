//
//  UIImage+RIRImageResizing.m
//  Pods
//
//  Created by Benjamin Maer on 10/7/16.
//
//

#import "UIImage+RIRImageResizing.h"





NSUInteger const kUIImage_RIRResizing_numberOfComponentsPerARBGPixel = 4;





@implementation UIImage (RIRImageResizing)

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
	if (self.size.width > self.size.height)
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	else
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	if (destWidth > newSize.width)
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}
	if (destHeight > newSize.height)
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}

	return [self rir_scaleToFillSize:(CGSize){
		.width		= destWidth,
		.height		= destHeight,
	}];
}

-(nonnull UIImage*)rir_scaleToFillSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, self.scale);
   
    [self drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(nonnull UIImage*)rir_scaleToCoverSize:(CGSize)newSize
{
	size_t destWidth, destHeight;
	CGFloat const widthRatio = newSize.width / self.size.width;
	CGFloat const heightRatio = newSize.height / self.size.height;
	/// Keep aspect ratio
	if (heightRatio > widthRatio)
	{
		destHeight = (size_t)newSize.height;
		destWidth = (size_t)(self.size.width * newSize.height / self.size.height);
	}
	else
	{
		destWidth = (size_t)newSize.width;
		destHeight = (size_t)(self.size.height * newSize.width / self.size.width);
	}

	return [self rir_scaleToFillSize:CGSizeMake(destWidth, destHeight)];
}

#pragma mark - imageHasAlpha
-(BOOL)rir_imageHasAlpha
{
	return [self.class rir_imageHasAlpha:self.CGImage];
}

#pragma mark - Static methods
+(BOOL)rir_imageHasAlpha:(CGImageRef)imageRef
{
	if (imageRef == nil)
	{
		NSAssert(false, @"should pass non nil imageRef");
		return NO;
	}

	CGImageAlphaInfo const alpha = CGImageGetAlphaInfo(imageRef);
	BOOL hasAlpha = (alpha == kCGImageAlphaFirst || alpha == kCGImageAlphaLast || alpha == kCGImageAlphaPremultipliedFirst || alpha == kCGImageAlphaPremultipliedLast);

	return hasAlpha;
}

#pragma mark - createARGBBitmapContext
+(nonnull CGContextRef)rir_createARGBBitmapContext:(const size_t)width height:(const size_t)height bytesPerRow:(const size_t)bytesPerRow withAlpha:(BOOL)withAlpha
{
	/// Use the generic RGB color space
	/// We avoid the NULL check because CGColorSpaceRelease() NULL check the value anyway, and worst case scenario = fail to create context
	/// Create the bitmap context, we want pre-multiplied ARGB, 8-bits per component
	CGImageAlphaInfo const alphaInfo = (withAlpha ? kCGImageAlphaPremultipliedFirst : kCGImageAlphaNoneSkipFirst);
	CGColorSpaceRef const colorSpace = CGColorSpaceCreateDeviceRGB();

	CGContextRef const bmContext = CGBitmapContextCreate(NULL, width, height, 8/*Bits per component*/, bytesPerRow, colorSpace, kCGBitmapByteOrderDefault | alphaInfo);

	CGColorSpaceRelease(colorSpace);

	return bmContext;
}

@end
