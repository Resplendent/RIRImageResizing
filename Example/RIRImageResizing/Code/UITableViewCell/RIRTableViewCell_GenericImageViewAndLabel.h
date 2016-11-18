//
//  RIRTableViewCell_GenericImageViewAndLabel.h
//  RIRImageResizing
//
//  Created by Richard Reitzfeld on 11/17/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface RIRTableViewCell_GenericImageViewAndLabel : UITableViewCell

#pragma mark - label
@property (nonatomic, strong, nullable) UILabel* label;

#pragma mark - nativeImageView
@property (nonatomic, strong, nullable) UIImageView* nativeImageView;

#pragma mark - exampleImageView
@property (nonatomic, strong, nullable) UIImageView* exampleImageView;


@end
