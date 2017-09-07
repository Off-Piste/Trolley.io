/////////////////////////////////////////////////////////////////////////////////
//
//  TRLLogger.m
//  TrolleyCore
//
//  Created by Harry Wright on 22.08.17.
//  Copyright © 2017 Off-Piste.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//   THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

#import <TrolleyCore/TRLLogger.h>
#import <TrolleyCore/TrolleyCore-Swift.h>

TRLLoggerService kTRLLoggerCore = @"[Trolley/Core]";

static TRLLogger *aLogger;

@implementation TRLLogger

+ (TRLLogger *)defaultLogger {
    if (aLogger) {
        return aLogger;
    }

    @synchronized (self) {
        aLogger = [[TRLLogger alloc] init];
        return aLogger;
    }
}

- (BOOL)isLogging {
    BOOL logging = [Trolley shared].isLogging;
    return logging;
}

- (void)printItems:(NSArray *)items
           service:(TRLLoggerService)service
             level:(TRLLoggerLevel)lvl
              file:(NSString *)aFile
          function:(NSString *)aFunction
              line:(NSUInteger)line
         seperator:(NSString *)seperator {
    if (![Trolley shared].isLogging) {
        NSLog(@"%i", [Trolley shared].isLogging);
        return;
    }

    NSString *levelString;
    switch (lvl) {
        case TRLLoggerLevelInfo: levelString = @"<INFO>";
        case TRLLoggerLevelDebug: levelString = @"<DEBUG>";
        case TRLLoggerLevelError: levelString = @"<ERROR>";
        case TRLLoggerLevelWarning: levelString = @"<WARNING>";
        default: break; //notice is for printing everything to the user
    }

    NSString *source = [NSString stringWithFormat:@"[%@:%@:%lu]",
                        aFile.lastPathComponent, aFunction, (unsigned long)line];

    NSString *msg = [items componentsJoinedByString:seperator];
    NSString *message;
    if (lvl == TRLLoggerLevelNotice) {
        message = [NSString stringWithFormat:@"%@ %@", service, msg];
    } else {
        message = [NSString stringWithFormat:@"%@ %@ %@ %@",
                   service, levelString, source, msg];
    }

    NSLog(@"%@", message);
}

- (void)printItems:(NSArray *)items
           service:(TRLLoggerService)service
             level:(TRLLoggerLevel)lvl
         seperator:(NSString *)seperator {
    if (![Trolley shared].isLogging) {
        return;
    }

    NSString *levelString;
    switch (lvl) {
        case TRLLoggerLevelInfo: levelString = @"<INFO>";
        case TRLLoggerLevelDebug: levelString = @"<DEBUG>";
        case TRLLoggerLevelError: levelString = @"<ERROR>";
        case TRLLoggerLevelWarning: levelString = @"<WARNING>";
        default: break; //notice is for printing everything to the user
    }

    NSString *msg = [items componentsJoinedByString:seperator];
    NSString *message;
    if (lvl == TRLLoggerLevelNotice) {
        message = [NSString stringWithFormat:@"%@ %@", service, msg];
    } else {
        message = [NSString stringWithFormat:@"%@ %@ %@",
                   service, levelString, msg];
    }

    NSLog(@"%@", message);
}

@end
