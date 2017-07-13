//
//  BasicCell_Objc.m
//  Trolley
//
//  Created by Harry Wright on 13.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#import "BasicCell_Objc.h"

@interface BasicCell_Objc ()

@property (weak, nonatomic) IBOutlet UILabel *title;

@end

@implementation BasicCell_Objc

+ (NSString *)reuseID {
    return @"BasicCell";
}

- (void)configureCell {
    TRLProduct *product = [self datasourceItem];
    [self.title setText:product.name];
}

@end
