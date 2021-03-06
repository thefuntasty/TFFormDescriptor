//
//  TFVisibilityViewController.m
//  TFFormDescriptor
//
//  Created by Jakub Knejzlik on 01/05/15.
//  Copyright (c) 2015 Ales Kocur. All rights reserved.
//

#import "TFVisibilityViewController.h"
#import <TFFormDescriptor.h>

@interface TFVisibilityViewController ()

@property TFFormDescriptor *formDescriptor;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TFVisibilityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    TFFormDescriptor *form = [TFFormDescriptor descriptorWithTable:self.tableView];
    
    TFFormSectionDescriptor *section = [TFFormSectionDescriptor descriptorWithTag:0 data:nil];
    
    TFFormFieldDescriptor *textField = [TFFormFieldDescriptor descriptorWithClass:[TFFormTitledTextField class] configuration:[TFFormTitledTextField configurationWithTitle:@"Name" placeholder:@"Your name"] key:@"name"];
    
    [section addRow:textField];
    
    TFFormFieldDescriptor *hasCarField = [TFFormFieldDescriptor descriptorWithClass:[TFFormTitledSwitchField class] configuration:[TFFormTitledSwitchField configurationWithTitle:@"Do You have car?"] key:@"hasCar"];
    
    [section addRow:hasCarField];
    
    
    textField = [TFFormFieldDescriptor descriptorWithClass:[TFFormTitledTextField class] configuration:[TFFormTitledTextField configurationWithTitle:@"Car brand" placeholder:@"fiat, seat, audi, kia, hyundai"] key:@"carBrand"];

    [textField setDisplayBlock:^BOOL(TFFormDescriptor *formDescriptor) {
        NSLog(@"%i",[[hasCarField value] boolValue]);
        return [[hasCarField value] boolValue];
    }];
    
    [section addRow:textField];
    
    
    [form addSection:section];

    section = [TFFormSectionDescriptor descriptorWithTag:1 data:nil];
    textField = [TFFormFieldDescriptor descriptorWithClass:[TFFormTitledTextField class] configuration:[TFFormTitledTextField configurationWithTitle:@"Row in section" placeholder:@"fiat, seat, audi, kia, hyundai"] key:nil];
    [section addRow:textField];

    
    [section setDisplayBlock:^BOOL(TFFormDescriptor *formDescriptor) {
        return [[hasCarField value] boolValue];
    }];
    
    [form addSection:section];
    
    self.formDescriptor = form;
    
}

@end
