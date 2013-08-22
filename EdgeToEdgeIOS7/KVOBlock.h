//
//  KVOBlock.h
//
//  A KVO observation via a callback block.  [Interim solution until Apple adds 
//  block callback support to KVO protocols.]
//
//  Created by Dan Craft on 12/6/10.
//  Copyright 2010 SmartAss Apps. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

#import <Foundation/Foundation.h>

typedef void (^KVOCallbackBlock)(NSObject *object, NSString *keyPath, NSDictionary *change); // same arguments as the KVO protocol's -observeValueForKeyPath:ofObject:change:context:, minus the context


@interface KVOBlock : NSObject

/* 
 Add a block observation to a key path of an object with specified options for the notification.
 
 Return an opaque object representing the observation, which can subsequently be used to remove the observation.  It must be retained for the duration of the observation.
 */
+(id)addObserverForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object withOptions:(NSKeyValueObservingOptions)options usingBlock:(KVOCallbackBlock)block;

// DEBT: add queue support for callback execution

+(void)removeObservation:(id)observation;

@end
