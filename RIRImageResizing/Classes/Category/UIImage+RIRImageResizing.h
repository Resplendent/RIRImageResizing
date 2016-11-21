//
//  UIImage+RIRImageResizing.h
//  Pods
//
//  Created by Benjamin Maer on 10/7/16.
//
//

#import <UIKit/UIKit.h>
#import "RIRResizeImageOperationParameters.h"





@interface UIImage (RIRImageResizing)

#pragma mark - scale
-(nonnull UIImage*)rir_scaledImage_withResizeOperationParameters:(RIRResizeImageOperationParameters*)parameters;

@end
