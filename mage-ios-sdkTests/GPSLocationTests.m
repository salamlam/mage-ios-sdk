//
//  GPSLocationTests.m
//  mage-ios-sdk
//

#import <XCTest/XCTest.h>
#import "GPSLocation.h"
#import "GeoPoint.h"
#import "OCMockito.h"


@interface GPSLocationTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation GPSLocationTests

- (void)setUp {
    [super setUp];

    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    self.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
}

- (void)tearDown {
    self.managedObjectContext = nil;
    [MagicalRecord cleanUp];
    
    [super tearDown];
}

- (void)testGpsLocationForLocation {
    
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:-1.0 longitude:1.0];
  
    [GPSLocation gpsLocationForLocation:testLocation inManagedObjectContext:self.managedObjectContext];
   
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
    XCTAssertFalse(self.managedObjectContext.hasChanges,"All the changes should be saved.");
    NSArray *allGpsLocations = [GPSLocation MR_findAllSortedBy:@"timestamp" ascending:YES inContext:self.managedObjectContext];
    XCTAssertEqual(allGpsLocations.count, 1, @"Only one GPSLocation should be saved.");
    for (GPSLocation *location in allGpsLocations) {
        GeoPoint *point = location.geometry;
        XCTAssertEqualWithAccuracy(point.location.coordinate.latitude, testLocation.coordinate.latitude, kCLLocationAccuracyNearestTenMeters, @"Latitude should be unchanged after saving.");
        XCTAssertEqualWithAccuracy(point.location.coordinate.longitude, testLocation.coordinate.longitude, kCLLocationAccuracyNearestTenMeters, @"Longitude should be unchanged after saving.");
        
    }
}

@end
