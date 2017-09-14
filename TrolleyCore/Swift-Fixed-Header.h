//
//  Swift-Fixed-Header.h
//  TRLNetwork
//
//  Created by Harry Wright on 14.09.17.
//  Copyright © 2017 Off-Piste. All rights reserved.
//

#ifndef Swift_Fixed_Header_h
#define Swift_Fixed_Header_h

/************************************************************************
 *                                                                      *
 *                                                                      *
 *                              NOTE:                                   *
 *                                                                      *
 *                                                                      *
 *     Any Bridged Classes or Extensions need to be defined before      *
 *     the -Swift Header or we are hit with huge errors, not sure       *
 *     why but -Swift cannot find said classes so crashes out.          *
 *                                                                      *
 *     So use this in place of #import <TRLNetwork/TRLNetwork-Swift.h>  *
 *                                                                      *
 ************************************************************************/

#import "TRLJSON.h"
#import "TRLURLDataRequest.h"
#import <TrolleyCore/TrolleyCore-Swift.h>

#endif /* Swift_Fixed_Header_h */
