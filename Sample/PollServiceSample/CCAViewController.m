//
//  CCAViewController.m
//  PollServiceSample
//
//  Created by Jean-Luc Dagon on 20/01/2014.
//  Copyright (c) 2014 Cocoapps. All rights reserved.
//

#import "CCAViewController.h"
#import "CCAPollService.h"

@interface CCAViewController ()
{
    
}

@property (nonatomic) IBOutlet UILabel *countLabel;
@property (nonatomic, strong) CCAPollService *countService;

@property (nonatomic, assign) NSInteger currentValue;

@end

@implementation CCAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    __weak typeof(self)weakSelf = self;
	self.countService = [CCAPollService serviceWithPollInterval:1 block:^(id service, NSError *error) {
        [weakSelf increment];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.countService start];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.countService stop];
}

- (void)increment
{
    self.currentValue++;
    self.countLabel.text = [@(self.currentValue) description];
}

- (IBAction)dismissModal:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
