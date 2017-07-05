//
//  URL_Objc.m
//  Trolley
//
//  Created by Harry Wright on 04.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

@import Trolley;
@import Quick;
@import Nimble;
#import "Trolley_Tests-Swift.h"
#import "Trolley_Tests-Bridging-Header.h"

@interface URL_Objc : QuickSpec

@end

@implementation URL_Objc

- (void)spec {
    describe(@"TRLNetworkManager", ^{
        describe(@"Invalid URL's", ^{
            context(@"Query Parameters as invalid", ^{
                it(@"Should be nil", ^{
                    waitUntil(^(void (^done)(void)){
                        TRLRequest *request = [[TRLNetworkManager shared] getDatabase:TRLDatabaseProducts];
                        TRLRequest *ratedRequest = [request rate:10];
                        [ratedRequest.validated responseDataWithHandler:^(NSData *data, NSError *err) {
                            expect(err).toNot(beNil());
                            done();
                        }];
                    });
                });
            });
        });
    });
}

@end
