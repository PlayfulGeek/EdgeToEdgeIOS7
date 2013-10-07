//
//  ScrollView.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/27/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "Logging.h"
#import "ScrollView.h"

@implementation ScrollView

- (void)setContentInset:(UIEdgeInsets)contentInset {
    [super setContentInset:contentInset];
    ScrollInsetPLog(@"top=%.0f bottom=%.0f", contentInset.top, contentInset.bottom);
}

@end
