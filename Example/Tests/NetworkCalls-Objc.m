//
//  NetworkCalls-Objc.m
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

@interface NetworkCalls_Objc : QuickSpec

@end

@implementation NetworkCalls_Objc
    
- (void)spec {
    describe(@"TRLNetworkManager", ^{
        // When the sever is running and you expect
        // this to fail, un-comment this line
//            xcontext(@"Server Is Unreachable", ^{
        context(@"Server Is Unreachable", ^{
            it(@"Error Should Not Be Nil", ^{
                TRLRequest *request = [[TRLNetworkManager shared]  getDatabase:TRLDatabaseProducts];
                
                waitUntil(^(void (^done)(void)){
                    [request responseJSONArray:^(NSArray *json, NSError *error) {
                        if (error)
                            expect(error).toNot(beNil());
                        done();
                    }];
                });
            });
        });
        
        context(@"Server Is Running", ^{
            it(@"Products count should be the same as json.count", ^{
                __block NSMutableArray<TRLProduct *> *products = [[NSMutableArray alloc] init];
                TRLRequest *request = [[TRLNetworkManager shared]  getDatabase:TRLDatabaseProducts];
                
                waitUntil(^(void (^done)(void)){
                    [request responseJSONArray:^(NSArray *json, NSError *error) {
                        if (error) {
                            done();
                        } else {
                            for (NSDictionary<NSString *, id> *jsonElement in json) {
                                NSError *error;
                                TRLProduct *product = [[TRLProduct alloc] initWithJSONData:jsonElement error:&error];
                                
                                if (error) {
                                    continue;
                                }
                                
                                [products addObject:product];
                            }
                            expect(products.count).to(equal(json.count));
                            done();
                        }
                    }];
                });
            });
        });
    });
    
}
@end
