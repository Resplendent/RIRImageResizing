//
//  RIRTableViewCell_GenericImageViewAndLabel.m
//  RIRImageResizing
//
//  Created by Richard Reitzfeld on 11/17/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RIRTableViewCell_GenericImageViewAndLabel.h"

#import <ResplendentUtilities/UIView+RUUtility.h>





@interface RIRTableViewCell_GenericImageViewAndLabel ()

#pragma mark - label
-(CGRect)label_frame;

#pragma mark - nativeImageView
-(CGRect)nativeImageView_frame;

#pragma mark - exampleImageView
-(CGRect)exampleImageView_frame;

@end





@implementation RIRTableViewCell_GenericImageViewAndLabel

#pragma mark - UITableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _label = [UILabel new];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.label setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.label];
        
        _nativeImageView = [UIImageView new];
        [self.nativeImageView setClipsToBounds:YES];
        [self.nativeImageView setBackgroundColor:[UIColor redColor]];
        
        [self.contentView addSubview:self.nativeImageView];
        
        _exampleImageView = [UIImageView new];
        [self.exampleImageView setClipsToBounds:YES];
        [self.exampleImageView setContentMode:UIViewContentModeCenter];
        [self.exampleImageView setBackgroundColor:[UIColor greenColor]];
        
        [self.contentView addSubview:self.exampleImageView];
        
        [self.contentView setClipsToBounds:YES];
        
        [self.contentView setBackgroundColor:[UIColor blueColor]];
    }
    
    return self;
}

#pragma mark - UIView
-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.label setFrame:self.label_frame];
    [self.nativeImageView setFrame:self.nativeImageView_frame];
    [self.exampleImageView setFrame:self.exampleImageView_frame];
}

#pragma mark - label
-(CGRect)label_frame
{
    return CGRectCeilOrigin((CGRect) {
        .size.width = CGRectGetWidth(self.contentView.bounds),
        .size.height = 30.0f
    });
}

#pragma mark - nativeImageView
-(CGRect)nativeImageView_frame
{
    return CGRectCeilOrigin((CGRect){
        .origin.y       = CGRectGetMaxY(self.label_frame),
        .size.width     = self.exampleImageView.image.size.width,
        .size.height    = self.exampleImageView.image.size.height
    });
}

#pragma mark - exampleImageView
-(CGRect)exampleImageView_frame
{
    return CGRectCeilOrigin((CGRect){
        .origin.y       = CGRectGetMaxY(self.nativeImageView_frame),
        .size.width     = self.exampleImageView.image.size.width,
        .size.height    = self.exampleImageView.image.size.height
    });
}

@end
