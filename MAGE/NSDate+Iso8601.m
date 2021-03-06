//
//  NSDate+Iso8601.m
//  mage-ios-sdk
//
//

#import "NSDate+Iso8601.h"

@implementation NSDate (Iso8601)

static NSDateFormatter* dateFormatter = nil;

- (NSString *) iso8601String {
    return [[NSDate getDateFormatter] stringFromDate:self];
}

+ (NSDate *) dateFromIso8601String: (NSString *) iso8601String {
    return [[NSDate getDateFormatter] dateFromString:iso8601String];
}

+ (NSDateFormatter *) getDateFormatter {
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    }
    
    return dateFormatter;
}


@end
