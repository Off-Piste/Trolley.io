//
//  ADXDatasource+Networking.m
//  Trolley
//
//  Created by Harry Wright on 13.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#import "ADXDatasource+Networking.h"

@implementation ADXDatasource (Networking)

- (void)startDownload {
    TRLRequest *request = [[TRLNetworkManager shared] getDatabase:TRLDatabaseProducts];
    [request responseJSONArray:^(NSArray *json, NSError *error) {
        NSMutableArray<TRLProduct *> *products;
        
        if (error) {
            NSLog(@"[Vivacity] Error: %@", error.localizedDescription);
            return;
        }
        
        for (NSDictionary<NSString *, id> *jsonElement in json) {
            NSError *error;
            TRLProduct *product = [[TRLProduct alloc] initWithJSONData:jsonElement error:&error];
            
            if (error) {
                continue;
            }
            
            [products addObject:product];
        }
        [self setObjects:products];
    }];

}

@end
