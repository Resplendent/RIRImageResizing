//
//  UIImage+RIRImageResizing.h
//  Pods
//
//  Created by Benjamin Maer on 10/7/16.
//
//

#import "RIRResizeImageOperationParameters.h"

#import <UIKit/UIKit.h>





@interface UIImage (RIRImageResizing)

#pragma mark - scale
-(nullable UIImage*)rir_scaledImage_withResizeOperationParameters:(nonnull RIRResizeImageOperationParameters*)parameters;

@end
