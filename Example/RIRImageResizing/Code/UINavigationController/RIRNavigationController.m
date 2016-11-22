//
//  RIRNavigationController.m
//  RIRImageResizing
//
//  Created by Richard Reitzfeld on 11/17/16.
//  Copyright © 2016 Benjamin Maer. All rights reserved.
//

#import "RIRNavigationController.h"
#import "RIRViewController.h"





@interface RIRNavigationController ()

@end





@implementation RIRNavigationController

#pragma mark - NSObject
-(instancetype)init
{
    return (self = [self initWithRootViewController:[RIRViewController new]]);
}
@end
