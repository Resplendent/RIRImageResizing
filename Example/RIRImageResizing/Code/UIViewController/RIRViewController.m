//
//  RIRViewController.m
//  RIRImageResizing
//
//  Created by Benjamin Maer on 10/07/2016.
//  Copyright (c) 2016 Benjamin Maer. All rights reserved.
//

#import "RIRViewController.h"

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>






typedef NS_ENUM(NSInteger, RIRViewController__tableView_section) {
    RIRViewController__tableView_section_originalImage,
    RIRViewController__tableView_section_resizedImages
    
};






@interface RIRViewController ()

@end





@implementation RIRViewController

#pragma mark - UIViewController
-(void)viewDidLoad
{
	[super viewDidLoad];
    	
	[self.view setBackgroundColor:[UIColor orangeColor]];
}

@end
