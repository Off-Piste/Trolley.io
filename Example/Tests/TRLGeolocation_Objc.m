//
//  TRLGeolocation_Objc.m
//  Trolley
//
//  Created by Harry Wright on 05.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

@import Trolley;
@import Quick;
@import Nimble;
#import "Trolley_Tests-Swift.h"
#import "Trolley_Tests-Bridging-Header.h"
#import <CoreLocation/CoreLocation.h>

@interface TRLGeolocation_Objc : QuickSpec

@end

@implementation TRLGeolocation_Objc

- (void)spec {
    describe(@"TRLGeolocation", ^{
        describe(@"Placemark", ^{
            // For some reason this timesout but
            // swift version runs fine??
            xit(@"Should Return a Placemark", ^{
                CLLocation *loc = [[CLLocation alloc] initWithLatitude:53.6763221
                                                             longitude:-1.9142865];
                __block NSString *postcode;
                [TRLGeolocation placemarkForLocation:loc
                                           withBlock:^(CLPlacemark *pm, NSError *err) {
                                               postcode = pm.postalCode;
                }];
                
                expect(postcode).toEventually(equal(@"HX4 0HL"));
                
            });
        });
    });

}

@end
