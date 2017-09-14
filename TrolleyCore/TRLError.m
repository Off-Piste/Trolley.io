/////////////////////////////////////////////////////////////////////////////////
//
//  NSObject+TRLError.m
//  RequestBuilder
//
//  Created by Harry Wright on 30.08.17.
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

#import "TRLError.h"

NSString * const TRLErrorDomain = @"io.off-piste";

NSError *TRLMakeError(TRLError code, NSString *_Nullable reason, ...) {
    NSMutableDictionary *userInfo = @{@"Error Code": @(code)}.mutableCopy;
    if (reason) {
        va_list args;
        va_start(args, reason);
        [userInfo setValue:[[NSString alloc] initWithFormat:reason arguments:args]
                    forKey:NSLocalizedDescriptionKey];
        va_end(args);
    }
    return [NSError errorWithDomain:TRLErrorDomain code:code userInfo:userInfo];
}

NSException *TRLException(NSString *reason, NSDictionary *additionalUserInfo) {
    NSMutableDictionary *userInfo = @{@"TrolleyVersion": @"0.1.0"}.mutableCopy;
    if (additionalUserInfo != nil) {
        [userInfo addEntriesFromDictionary:additionalUserInfo];
    }
    NSException *e = [NSException exceptionWithName:@"TRLException"
                                             reason:reason
                                           userInfo:userInfo];
    return e;
}

void TRLSetErrorOrThrow(NSError *error, NSError **outError) {
    if (outError) {
        *outError = error;
    } else {
        NSString *msg = error.localizedDescription;
        if (error.userInfo[NSFilePathErrorKey]) {
            msg = [NSString stringWithFormat:@"%@: %@", error.userInfo[NSFilePathErrorKey], error.localizedDescription];
        }
        @throw TRLException(msg, @{NSUnderlyingErrorKey: error});
    }
}
