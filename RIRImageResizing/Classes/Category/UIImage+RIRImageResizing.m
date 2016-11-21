//
//  UIImage+RIRImageResizing.m
//  Pods
//
//  Created by Benjamin Maer on 10/7/16.
//
//

#import "UIImage+RIRImageResizing.h"
#import "RIRResizeImageOperation.h"





@implementation UIImage (RIRImageResizing)

#pragma mark - scale
-(UIImage *)rir_scaledImage_withResizeOperationParameters:(RIRResizeImageOperationParameters *)parameters
{
    RIRResizeImageOperation* image_scale_operation = [[RIRResizeImageOperation alloc] init_with_resizeParameters:parameters image:self];
    return [image_scale_operation resizedImage];
}


@end
