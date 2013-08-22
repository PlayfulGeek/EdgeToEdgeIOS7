//
//  KVOBlock.m
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

#import "KVOBlock.h"

@interface KVOBlock ()
@property(nonatomic,retain) NSObject *observeeRoot;
@property(nonatomic,retain) NSString *observeeKeyPath;
@property(nonatomic,copy) KVOCallbackBlock callbackBlock; // copy ensures on heap
@end


@implementation KVOBlock

// Note: Distinct observers are required to distinguish among multiple observations on the same object and key path during removal.

+(id)addObserverForKeyPath:(NSString *)keyPath ofObject:(NSObject *)object withOptions:(NSKeyValueObservingOptions)options usingBlock:(KVOCallbackBlock)block {
    KVOBlock *observation = [[KVOBlock alloc] init];
    observation.observeeRoot = object;
    observation.observeeKeyPath = keyPath;
    observation.callbackBlock = block;
    [object addObserver:observation forKeyPath:keyPath options:options context:(__bridge void *)observation.callbackBlock];
    return observation;
}

+(void)removeObservation:(id)observation {
    NSAssert1([observation isKindOfClass:[KVOBlock class]], @"Illegal argument provided to KVOBlock removeObservation; its class is %@ (expected KVOBlock)", NSStringFromClass([observation class]));
    KVOBlock *o = observation;
    [o.observeeRoot removeObserver:o forKeyPath:o.observeeKeyPath];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    ((__bridge KVOCallbackBlock)context)(object, keyPath, change);
}

@synthesize callbackBlock, observeeKeyPath, observeeRoot;

@end
