//
//  TRLJSONBase_Private.h
//  TrolleyNetworkingTools
//
//  Created by Harry Wright on 05.09.17.
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

#import "TRLJSONBase.h"

@class WrittingOptions;

NS_ASSUME_NONNULL_BEGIN

/**
 <#Description#>

 @param lhs <#lhs description#>
 @param rhs <#rhs description#>
 @return <#return value description#>
 */
FOUNDATION_EXTERN BOOL TRLJSONBaseIsEqual(TRLJSONBase *lhs, TRLJSONBase *rhs);

/**
 <#Description#>

 @param base <#base description#>
 @param encoding <#encoding description#>
 @param opt <#opt description#>
 @param depth <#depth description#>
 @param error <#error description#>
 @return <#return value description#>
 */
FOUNDATION_EXTERN NSString *_Nullable RawJSONStringForTRLJSONBase(
    TRLJSONBase *base,
    NSStringEncoding encoding,
    NSArray<WrittingOptions *> * opt,
    int depth,
    NSError **error
);

NS_ASSUME_NONNULL_END
