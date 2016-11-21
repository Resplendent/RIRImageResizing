//
//  RIRResizeImageOperationParameters.h
//  Pods
//
//  Created by Richard Reitzfeld on 11/21/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, UIImage_RIRResizing_ResizeMode) {
    UIImage_RIRResizing_ResizeMode_ScaleToFill,
    UIImage_RIRResizing_ResizeMode_AspectFit,
    UIImage_RIRResizing_ResizeMode_AspectFill,
    
    UIImage_RIRResizing_ResizeMode_first = UIImage_RIRResizing_ResizeMode_ScaleToFill,
    UIImage_RIRResizing_ResizeMode_last = UIImage_RIRResizing_ResizeMode_AspectFill
};




@interface RIRResizeImageOperationParameters : NSObject

#pragma mark - newSize
@property (nonatomic) CGSize newSize;

#pragma mark - resizeMode
@property (nonatomic) UIImage_RIRResizing_ResizeMode resizeMode;

#pragma mark - scalse
@property (nonatomic) CGFloat scale;

#pragma mark - init
-(nullable instancetype)init_with_newSize:(CGSize)newSize
                               resizeMode:(UIImage_RIRResizing_ResizeMode)resizeMode;

@end
