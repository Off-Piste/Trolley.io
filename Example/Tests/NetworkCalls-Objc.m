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

        // This is also tested in NetworkCalls_Swift.swift
        describe(@"Fix For #4", ^{
            
            // When the sever is running and you expect
            // this to fail, un-comment this line
//            xcontext(@"Server Is Unreachable", ^{
            context(@"Server Is Down", ^{
                it(@"Error Should Not Be Nil", ^{
                    TRLRequest *request = [[TRLNetworkManager shared]  getDatabase:TRLDatabaseProducts];
                    waitUntil(^(void (^done)(void)){
                        [request responseProductsWithBlock:^(NSArray<TRLProduct *> *products, NSError *error) {
                            expect(error).toNot(beNil());
                            done();
                        }];
                    });
                });
            });
        });
    });
    
}
@end
