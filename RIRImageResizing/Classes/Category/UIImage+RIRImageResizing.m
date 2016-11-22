//
//  UIImage+RIRImageResizing.m
//  Pods
//
//  Created by Benjamin Maer on 10/7/16.
//
//

#import "UIImage+RIRImageResizing.h"
#import "RIRResizeImageOperation.h"

#import <ResplendentUtilities/RUConditionalReturn.h>





@implementation UIImage (RIRImageResizing)

#pragma mark - scale
-(nullable UIImage*)rir_scaledImage_with_resizeOperationParameters:(nonnull RIRResizeImageOperationParameters*)parameters
{
    kRUConditionalReturn_ReturnValueNil(parameters == nil, YES);
    
    RIRResizeImageOperation* const image_scale_operation = [[RIRResizeImageOperation alloc] init_with_resizeParameters:parameters image:self];
    
    kRUConditionalReturn_ReturnValueNil(image_scale_operation == nil, YES);
    
    return [image_scale_operation resizedImage];
}


@end
