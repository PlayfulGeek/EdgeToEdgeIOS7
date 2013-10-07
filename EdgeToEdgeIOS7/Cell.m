//
//  Nav0Cell.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 8/26/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "Cell.h"

@interface Cell ()
@property (weak, nonatomic) IBOutlet UILabel *cellLabel;
@end

@implementation Cell

-(void)setCellNumber:(NSInteger)cellNumber {
    _cellNumber = cellNumber;
    self.cellLabel.text = [NSString stringWithFormat:@"Cell %d", self.cellNumber];
}

@end
