//
//  Logging.m
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 10/7/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import "Logging.h"

void IndentLog(LogIndentation indentation, NSString *format, ...) {
    static NSInteger indent = 0;
    
    if (indentation == LogIndentationOut) {
        indent--;
    }
    NSMutableString *indentationString = [NSMutableString string];
    for (NSInteger i = 0; i < indent; i++) {
        [indentationString appendString:@"    "];
    }
    if (indentation == LogIndentationIn) {
        indent++;
    }
    
    NSString *indentedFormat = [NSString stringWithFormat:(indentation == LogIndentationIn
                                                           ? @"%@ %@ {"
                                                           : (indentation == LogIndentationSame
                                                              ? @"%@ %@"
                                                              : @"%@ } %@")),
                                indentationString, format];
    
    va_list argumentList;
    va_start(argumentList, format);
    NSLogv(indentedFormat, argumentList);
    va_end(argumentList);
}