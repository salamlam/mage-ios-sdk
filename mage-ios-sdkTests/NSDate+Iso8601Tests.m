//
//  NSDate+Iso8601Tests.m
//  mage-ios-sdk
//

#import <XCTest/XCTest.h>
#import "NSDate+Iso8601.h"


@interface NSDate_Iso8601Tests : XCTestCase
@property NSDateFormatter *defaultDateFormatter;
@end

@interface NSDate (Tests)
+ (NSDateFormatter *)getDateFormatter;
@end

@implementation NSDate_Iso8601Tests

- (void)setUp {
    [super setUp];
    self.defaultDateFormatter = [[NSDateFormatter alloc] init];
    [self.defaultDateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [self.defaultDateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testIso8601DefaultTimeZone {
    NSTimeZone *defaultTimeZone = [self.defaultDateFormatter timeZone];
    
    NSDateFormatter *iso8601DefaultDateFormatter = [NSDate getDateFormatter];
    NSTimeZone *iso8601TimeZone = [iso8601DefaultDateFormatter timeZone];
    
    XCTAssertEqualObjects(defaultTimeZone.name, iso8601TimeZone.name, @"Time Zone different");
}

- (void)testIso8601DefaultDateFormat {
    NSString *defaultFormat = [self.defaultDateFormatter dateFormat];
    
    NSDateFormatter *iso8601DefaultDateFormatter = [NSDate getDateFormatter];
    NSString *iso8601Format = [iso8601DefaultDateFormatter dateFormat];
    
    XCTAssertEqual(defaultFormat, iso8601Format, @"Format different");
}

- (void)testIso8601StringNil {
    NSString *nilIso8601String = nil;
    NSDate *defaultDate = [self.defaultDateFormatter dateFromString:nilIso8601String];
    
    NSDate *nilDate = [NSDate dateFromIso8601String:nilIso8601String];

    XCTAssertEqual(defaultDate, nilDate);
}

@end
