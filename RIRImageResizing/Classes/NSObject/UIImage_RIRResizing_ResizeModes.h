//
//  UIImage_RIRResizing_ResizeModes.h
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#ifndef UIImage_RIRResizing_ResizeModes_h
#define UIImage_RIRResizing_ResizeModes_h

#import <ResplendentUtilities/RUEnumIsInRangeSynthesization.h>





typedef NS_ENUM(NSInteger, UIImage_RIRResizing_ResizeMode) {
    UIImage_RIRResizing_ResizeMode_none,
    
    UIImage_RIRResizing_ResizeMode_scaleToFill,
    UIImage_RIRResizing_ResizeMode_aspectFit,
    UIImage_RIRResizing_ResizeMode_aspectFill,
    
    UIImage_RIRResizing_ResizeMode__first = UIImage_RIRResizing_ResizeMode_scaleToFill,
    UIImage_RIRResizing_ResizeMode__last = UIImage_RIRResizing_ResizeMode_aspectFill
};

static inline RUEnumIsInRangeSynthesization_autoFirstLast(UIImage_RIRResizing_ResizeMode);





#endif /* UIImage_RIRResizing_ResizeModes_h */
