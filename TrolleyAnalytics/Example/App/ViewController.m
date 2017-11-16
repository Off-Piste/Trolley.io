//
//  ViewController.m
//  App
//
//  Created by Harry Wright on 10.10.17.
//  Copyright © 2017 Trolley. All rights reserved.
//

#import "ViewController.h"

@import Trolley;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [TRLReporting logCustomEventWithName:@"viewDidLoad" customAttributes:NULL];
}

@end
