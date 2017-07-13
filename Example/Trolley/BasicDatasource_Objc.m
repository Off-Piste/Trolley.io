//
//  BasicDatasource_Objc.m
//  Trolley
//
//  Created by Harry Wright on 13.07.17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

#import "BasicDatasource_Objc.h"

@implementation BasicDatasource_Objc

- (NSArray<id> *)collectionCellClasses {
    return @[[BasicCell_Objc copy]];
}

@end
