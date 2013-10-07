//
//  Logging.h
//  EdgeToEdgeIOS7
//
//  Created by Dan Craft on 10/7/13.
//  Copyright (c) 2013 955 Dreams. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LogIndentationOut = -1,
    LogIndentationSame   =  0,
    LogIndentationIn =  1,
} LogIndentation;

void IndentLog(LogIndentation indentation, NSString *format, ...);

#define _ScrollInsetPLog(indentation, fmt, ...) //IndentLog(indentation, (@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#define ScrollInsetPLog(fmt, ...) _ScrollInsetPLog(LogIndentationSame, fmt, ##__VA_ARGS__);
#define ScrollInsetPLogIn(fmt, ...) _ScrollInsetPLog(LogIndentationIn, fmt, ##__VA_ARGS__);
#define ScrollInsetPLogOut(fmt, ...) _ScrollInsetPLog(LogIndentationOut, fmt, ##__VA_ARGS__);

#define _StatusBarPLog(indentation, fmt, ...) IndentLog(indentation, (@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#define StatusBarPLog(fmt, ...) _StatusBarPLog(LogIndentationSame, fmt, ##__VA_ARGS__);
#define StatusBarPLogIn(fmt, ...) _StatusBarPLog(LogIndentationIn, fmt, ##__VA_ARGS__);
#define StatusBarPLogOut(fmt, ...) _StatusBarPLog(LogIndentationOut, fmt, ##__VA_ARGS__);

#define _MiscPLog(indentation, fmt, ...) IndentLog(indentation, (@"%s " fmt), __PRETTY_FUNCTION__, ##__VA_ARGS__);
#define MiscPLog(fmt, ...) _MiscPLog(LogIndentationSame, fmt, ##__VA_ARGS__);
#define MiscPLogIn(fmt, ...) _MiscPLog(LogIndentationIn, fmt, ##__VA_ARGS__);
#define MiscPLogOut(fmt, ...) _MiscPLog(LogIndentationOut, fmt, ##__VA_ARGS__);

#define _MiscLog(indentation, fmt, ...) IndentLog(indentation, fmt, ##__VA_ARGS__);
#define MiscLog(fmt, ...) _MiscLog(LogIndentationSame, fmt, ##__VA_ARGS__);
#define MiscLogIn(fmt, ...) _MiscLog(LogIndentationIn, fmt, ##__VA_ARGS__);
#define MiscLogOut(fmt, ...) _MiscLog(LogIndentationOut, fmt, ##__VA_ARGS__);
