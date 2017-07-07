//
//  Money_Objc.m
//  Trolley
//
//  Created by Harry Wright on 07.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

@import Trolley;
@import Quick;
@import Nimble;
#import "Trolley_Tests-Swift.h"
#import "Trolley_Tests-Bridging-Header.h"

@interface Money_Objc : QuickSpec

@end

@implementation Money_Objc

- (void)spec {
    describe(@"Money", ^{
        context(@"", ^{
            it(@"Should Pass", ^{
                TRLMoney *money = [[TRLMoney alloc] initWithNumber:@78];
                if (money.currency == TRLCurrencyCodeUSD) {
                    bool pass = YES;
                    expect(pass).to(equal(YES));
                }
                
                expect(money.stripe).to(equal(7800));
                expect(money.negative.intValue).to(equal(-78));
                    
            });
        });
    });
}

@end
