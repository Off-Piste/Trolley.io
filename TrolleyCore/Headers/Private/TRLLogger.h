/////////////////////////////////////////////////////////////////////////////////
//
//  TRLLogger.h
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

#import <Foundation/Foundation.h>
#import "TRLLoggerLevel.h"

NS_ASSUME_NONNULL_BEGIN

//extern BOOL kIsLogging;

@interface TRLLogger : NSObject

@property (strong, class, readonly) TRLLogger *defaultLogger;

@property (readonly) BOOL isLogging;

- (void)printItems:(NSArray *)items
           service:(TRLLoggerService)service
             level:(TRLLoggerLevel)lvl
              file:(NSString *)aFile
          function:(NSString *)aFunction
              line:(NSUInteger)line
         seperator:(NSString *)seperator;

- (void)printItems:(NSArray *)items
           service:(TRLLoggerService)service
             level:(TRLLoggerLevel)lvl
         seperator:(NSString *)seperator;

@end

#define CoreLogger(lvl, msg) do { \
if (TRLLogger.defaultLogger.isLogging) { \
NSString *levelString;\
switch (lvl) { \
case TRLLoggerLevelInfo: levelString = @" <INFO> "; \
case TRLLoggerLevelDebug: levelString = @" <DEBUG> "; \
case TRLLoggerLevelError: levelString = @" <ERROR> "; \
case TRLLoggerLevelWarning: levelString = @" <WARNING> "; \
default: levelString = @" "; \
} \
\
NSLog(@"%@%@[%@:%@:%d] %@", kTRLLoggerCore, levelString, [NSString stringWithFormat: @"%s", __FILE__].lastPathComponent, [NSString stringWithFormat: @"%s", __PRETTY_FUNCTION__],__LINE__, msg); } }while(0);


NS_ASSUME_NONNULL_END
