//
//  TRLPercentage.m
//  Trolley
//
//  Created by Harry Wright on 10.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

@import Trolley;
@import Quick;
@import Nimble;
#import "Trolley_Tests-Swift.h"
#import "Trolley_Tests-Bridging-Header.h"

@interface TRLPercentage_Objc : QuickSpec

@end

@implementation TRLPercentage_Objc

- (void)spec {
    describe(@"Percentage", ^{
        context(@"Initalised Properties", ^{
            it(@"Should Pass", ^{
                TRLPercentage *percentage = [[TRLPercentage alloc] initWithNumber:@55];
                expect(percentage.description).to(equal(@"55%"));
                expect(percentage.decimalValue).to(equal(0.55));
            });
        });
        
        context(@"Factory Methods", ^{
            it(@"Should Pass `.for`", ^{
                TRLPercentage *percentage = [TRLPercentage forValues:10 inValue:50];
                expect(percentage.description).to(equal(@"20%"));
                expect(percentage.decimalValue).to(equal(0.2));
            });
        });
    });
}

@end
