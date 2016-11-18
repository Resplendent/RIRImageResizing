//
//  RIRViewController.m
//  RIRImageResizing
//
//  Created by Benjamin Maer on 10/07/2016.
//  Copyright (c) 2016 Benjamin Maer. All rights reserved.
//

#import "RIRViewController.h"
#import "RIRTableViewCell_GenericImageViewAndLabel.h"
#import "UIImage+RIRImageResizing.h"

#import <ResplendentUtilities/RUConditionalReturn.h>
#import <ResplendentUtilities/UIView+RUUtility.h>

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>
#import <RTSMTableSectionManager/RTSMTableSectionRangeManager.h>






typedef NS_ENUM(NSInteger, RIRViewController__tableView_section) {
    RIRViewController__tableView_section_originalImage,
    RIRViewController__tableView_section_resizedImages
};






@interface RIRViewController () <UITableViewDataSource,UITableViewDelegate,RTSMTableSectionManager_SectionDelegate, RTSMTableSectionRangeManager_SectionLengthDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

#pragma mark - height_and_width_controlView
@property (nonatomic, readonly, strong, nullable) UIView* height_and_width_controlView;
-(CGRect)height_and_width_controlView_frame;

#pragma mark - imageHeight
@property (nonatomic) NSInteger imageHeight;

#pragma mark - imageWidth
@property (nonatomic) NSInteger imageWidth;

#pragma mark - imageSize
-(CGSize)imageSize;

#pragma mark - heightLabel
@property (nonatomic, readonly, strong, nullable) UILabel* heightLabel;
-(CGRect)heightLabel_frame;

#pragma mark - heightTextField
@property (nonatomic, readonly, strong, nullable) UITextField* heightTextField;
-(CGRect)heightTextField_frame;

#pragma mark - widthLabel
@property (nonatomic, readonly, strong, nullable) UILabel* widthLabel;
-(CGRect)widthLabel_frame;

#pragma mark - widthTextField
@property (nonatomic, readonly, strong, nullable) UITextField* widthTextfield;
-(CGRect)widthTextfield_frame;


#pragma mark - tableView
@property (nonatomic, readonly, strong, nullable) UITableView* tableView;
-(CGRect)tableView_frame;

#pragma mark - image
@property (nonatomic, strong, nullable) UIImage* image;
-(void)addImageBarButtonItem_didTouchUpInside;
-(nullable UIImage*)rescaledImage:(nullable UIImage*)image forIndexpath:(nullable NSIndexPath*)indexPath;

#pragma mark - cell helpers
-(nonnull NSString*)labelTextForCellAtIndexPath:(NSIndexPath*)indexPath;
-(nonnull NSString*)labelTextForResizedImageCellAtIndexPath:(NSIndexPath*)indexPath;
-(CGFloat)cellHeight;
-(UIViewContentMode)viewContentModeForNativeImageViewAtIndexPath:(NSIndexPath*)indexPath;

#pragma mark - tableSectionManager
@property (nonatomic, readonly, strong, nullable) RTSMTableSectionManager* tableSectionManager;

#pragma mark - tableSectionRangeManager
@property (nonatomic, readonly, strong, nullable) RTSMTableSectionRangeManager* tableSectionRangeManager;

#pragma mark - textField helper
-(void)textDidChange;

@end





@implementation RIRViewController

#pragma mark - UIViewController
-(void)viewDidLoad
{
	[super viewDidLoad];
    
    [self.navigationItem setTitle:@"RIRImageResizing"];
    
    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addImageBarButtonItem_didTouchUpInside)]];
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    _height_and_width_controlView = [UIView new];
    [self.height_and_width_controlView setBackgroundColor:[UIColor greenColor]];
    [self.view addSubview:self.height_and_width_controlView];
    
    _heightLabel = [UILabel new];
    [self.heightLabel setText:@"HEIGHT:"];
    [self.height_and_width_controlView addSubview:self.heightLabel];
    
    _heightTextField = [UITextField new];
    [self.heightTextField setBackgroundColor:[UIColor whiteColor]];
    [self.heightTextField setKeyboardType:UIKeyboardTypeNumberPad];

    [self.height_and_width_controlView addSubview:self.heightTextField];
    
    _widthLabel = [UILabel new];
    [self.widthLabel setText:@"WIDTH:"];
    [self.height_and_width_controlView addSubview:self.widthLabel];
    
    _widthTextfield = [UITextField new];
    [self.widthTextfield setBackgroundColor:[UIColor whiteColor]];
    [self.widthTextfield setKeyboardType:UIKeyboardTypeNumberPad];
    [self.height_and_width_controlView addSubview:self.widthTextfield];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLineEtched];
    [self.view addSubview:self.tableView];
    
    _tableSectionManager = [[RTSMTableSectionManager alloc] initWithFirstSection:RIRViewController__tableView_section_originalImage lastSection:RIRViewController__tableView_section_resizedImages];
    [self.tableSectionManager setSectionDelegate:self];
    
    RTSMTableSectionManager* tableSectionManager_forTableSectionRangeManager = [[RTSMTableSectionManager alloc] initWithFirstSection:UIImage_RIRResizing_ResizeMode_first lastSection:UIImage_RIRResizing_ResizeMode_last];
    [tableSectionManager_forTableSectionRangeManager setSectionDelegate:self];
   
    _tableSectionRangeManager = [RTSMTableSectionRangeManager new];
    [self.tableSectionRangeManager setTableSectionManager:tableSectionManager_forTableSectionRangeManager];
    [self.tableSectionRangeManager setSectionLengthDelegate:self];
    	
	[self.view setBackgroundColor:[UIColor orangeColor]];
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    [self.height_and_width_controlView setFrame:self.height_and_width_controlView_frame];
    [self.heightLabel setFrame:self.heightLabel_frame];
    [self.heightTextField setFrame:self.heightTextField_frame];
    [self.widthLabel setFrame:self.widthLabel_frame];
    [self.widthTextfield setFrame:self.widthTextfield_frame];
    
    [self.tableView setFrame:self.tableView_frame];
}

#pragma mark - RTSMTableSectionManager_SectionDelegate
-(BOOL)tableSectionManager:(RTSMTableSectionManager *)tableSectionManager sectionIsAvailable:(NSInteger)section
{
    return YES;
}

#pragma mark - RTSMTableSectionRangeManager_SectionLengthDelegate
-(NSUInteger)tableSectionRangeManager:(RTSMTableSectionRangeManager *)tableSectionRangeManager lengthOfSection:(NSInteger)section
{
    RIRViewController__tableView_section const tableSection = [self.tableSectionManager indexPathSectionForSection:section];
    
    switch (tableSection)
    {
        case RIRViewController__tableView_section_originalImage:
            return 1;
            break;
            
        case RIRViewController__tableView_section_resizedImages:
            return tableSectionRangeManager.tableSectionManager.numberOfSectionsAvailable;
            break;
    }
}

#pragma mark - height_and_width_controlView
-(CGRect)height_and_width_controlView_frame
{
    return CGRectCeilOrigin((CGRect){
        .size.width     = CGRectGetWidth(self.view.bounds),
        .size.height    = 100.0f
    });
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.heightTextField resignFirstResponder];
    [self.widthTextfield resignFirstResponder];
}

#pragma mark - heightLabel
-(CGRect)heightLabel_frame
{
    return CGRectCeilOrigin((CGRect){
        .origin.x       = 10.0f,
        .origin.y       = 10.0f,
        .size.width     = 70.0f,
        .size.height    = 30.0f
    });
}

#pragma mark - heightTextField
-(CGRect)heightTextField_frame
{
    return CGRectCeilOrigin((CGRect){
        .origin.x       = CGRectGetMinX(self.heightLabel_frame),
        .origin.y       = CGRectGetMaxY(self.heightLabel_frame) + 10.0f,
        .size.width     = 70.0f,
        .size.height    = 30.0f
    });
}

#pragma mark - widthLabel
-(CGRect)widthLabel_frame
{
    CGFloat const width = 70.0f;

    return CGRectCeilOrigin((CGRect){
        .origin.x       = CGRectGetMaxX(self.view.bounds) - width - 10.0f,
        .origin.y       = 10.0f,
        .size.width     = width,
        .size.height    = 30.0f
    });
}

#pragma mark - widthTextField
-(CGRect)widthTextfield_frame
{
    return CGRectCeilOrigin((CGRect){
        .origin.x       = CGRectGetMinX(self.widthLabel_frame),
        .origin.y       = CGRectGetMaxY(self.widthLabel_frame) + 10.0f,
        .size.width     = 70.0f,
        .size.height    = 30.0f
    });
}

#pragma mark = tableView
-(CGRect)tableView_frame
{
    return CGRectCeilOrigin((CGRect){
        .origin.y       = CGRectGetMaxY(self.height_and_width_controlView_frame),
        .size.width     = CGRectGetWidth(self.view.bounds),
        .size.height    = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(self.height_and_width_controlView_frame)
    });
}

#pragma mark - image
-(void)addImageBarButtonItem_didTouchUpInside
{
    UIImagePickerController* const imagePickerController = [[UIImagePickerController alloc] init];
    [imagePickerController setDelegate:self];
    
    UIAlertController* const alertController = [UIAlertController alertControllerWithTitle:@"Choose an image" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction* const cameraAction = [UIAlertAction actionWithTitle:@"Camera" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypeCamera];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
        [alertController addAction:cameraAction];

    }
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIAlertAction* const photoLibraryAction = [UIAlertAction actionWithTitle:@"Photo Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [imagePickerController setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
            [self presentViewController:imagePickerController animated:YES completion:nil];
        }];
    
        [alertController addAction:photoLibraryAction];
    }
   
    UIAlertAction* const cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

-(nullable UIImage*)rescaledImage:(nullable UIImage*)image forIndexpath:(nullable NSIndexPath*)indexPath
{
    kRUConditionalReturn_ReturnValueNil(image == nil, NO);
    kRUConditionalReturn_ReturnValueNil(indexPath == nil, NO);

    UIImage_RIRResizing_ResizeMode resizeModeForRow = [self.tableSectionRangeManager.tableSectionManager sectionForIndexPathSection:indexPath.row];

    return [image rir_scaleToSize:self.imageSize usingMode:resizeModeForRow];
}
#pragma mark - UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
   
    if (image)
    {
        [self setImage:image];
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        [self.tableView reloadData];
    }];
}

#pragma mark - cell helpers
-(NSString *)labelTextForCellAtIndexPath:(NSIndexPath *)indexPath
{
    RIRViewController__tableView_section const section = [self.tableSectionRangeManager sectionForIndexPathSection:indexPath.section];
    
    switch (section)
    {
        case RIRViewController__tableView_section_originalImage:
            return @"Original Image";
            break;
            
        case RIRViewController__tableView_section_resizedImages:
            return [self labelTextForResizedImageCellAtIndexPath:indexPath];
            break;
    }
}

-(NSString *)labelTextForResizedImageCellAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage_RIRResizing_ResizeMode resizeModeForRow = [self.tableSectionRangeManager.tableSectionManager sectionForIndexPathSection:indexPath.row];
    
    switch (resizeModeForRow) {
        case UIImage_RIRResizing_ResizeMode_ScaleToFill:
            return @"Scale to Fill";
            break;
            
        case UIImage_RIRResizing_ResizeMode_AspectFit:
            return @"Aspect Fit";
            break;
            
        case UIImage_RIRResizing_ResizeMode_AspectFill:
            return @"Aspect Fill";
            break;
            
        default:
            break;
    }
    return @"";
}

-(CGFloat)cellHeight
{
    return self.imageHeight;
}

-(UIViewContentMode)viewContentModeForNativeImageViewAtIndexPath:(NSIndexPath *)indexPath
{
    UIImage_RIRResizing_ResizeMode resizeModeForRow = [self.tableSectionRangeManager.tableSectionManager sectionForIndexPathSection:indexPath.row];
    
    switch (resizeModeForRow) {
        case UIImage_RIRResizing_ResizeMode_ScaleToFill:
            return UIViewContentModeScaleToFill;
            break;
            
        case UIImage_RIRResizing_ResizeMode_AspectFit:
            return UIViewContentModeScaleAspectFit;
            break;
            
        case UIImage_RIRResizing_ResizeMode_AspectFill:
            return UIViewContentModeScaleAspectFill;
            break;
            
        default:
            break;
    }
    return UIViewContentModeScaleAspectFit;

}

#pragma mark - UITableViewDelegate, UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.tableSectionManager.numberOfSectionsAvailable;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self tableSectionRangeManager:self.tableSectionRangeManager lengthOfSection:section];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RIRTableViewCell_GenericImageViewAndLabel* cell = [RIRTableViewCell_GenericImageViewAndLabel new];
    [cell.label setText:[self labelTextForCellAtIndexPath:indexPath]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    UIImage* image = [self rescaledImage:self.image forIndexpath:indexPath];
    if (image)
    {
        [cell.exampleImageView setImage:image];
        [cell.nativeImageView setImage:self.image];
        [cell.nativeImageView setContentMode:[self viewContentModeForNativeImageViewAtIndexPath:indexPath]];
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        return 250.0f;
    }
    return (self.imageHeight) * 2.0f + 30.0f;
}

#pragma mark - imageSize
-(CGSize)imageSize
{
    return (CGSize){
        .height = self.imageHeight,
        .width  = self.imageWidth
    };
}

#pragma mark - textField helper
-(void)textDidChange
{
    NSInteger const heightInteger = [self.heightTextField.text integerValue];
    NSInteger const widthInteger = [self.widthTextfield.text integerValue];
    if (heightInteger != self.imageHeight)
    {
        self.imageHeight = heightInteger;
    }
    
    if (widthInteger != self.imageWidth)
    {
        self.imageWidth = widthInteger;
    }
    
    [self.tableView reloadData];
}



@end
