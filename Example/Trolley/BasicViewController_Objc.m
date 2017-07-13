//
//  BasicViewController_Objc.m
//  Trolley
//
//  Created by Harry Wright on 13.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#import "BasicViewController_Objc.h"

@interface BasicViewController_Objc ()

@end

@implementation BasicViewController_Objc

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ADXDatasource *datasource = [[ADXDatasource alloc]
                                 initWithCollectionView:[self collectionView]];
    [self setDatasource:datasource];
    [self.datasource startDownload];
}


@end
