//
//  GPSLocationTests.m
//  mage-ios-sdk
//

#import <XCTest/XCTest.h>
#import "GPSLocation.h"
#import "GeoPoint.h"
#import "Server.h"
#import "OCMockito.h"
#import "OHHTTPStubs.h"
#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "HttpManager.h"


@interface GPSLocationTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) NSString *mageServerBaseUrl;
@property (nonatomic, retain) NSString *serverCurrentEventId;
@end

@interface NSDate (Tests)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day minute:(NSInteger)minute second:(NSInteger)second;

@end

@implementation NSDate (Tests)

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day minute:(NSInteger)minute second:(NSInteger)second {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    [components setMinute:minute];
    [components setSecond:second];
    return [calendar dateFromComponents:components];
}

@end

@implementation GPSLocationTests

- (void)setUp {
    [super setUp];
    
    //Setup in-memory MagicalRecord ManagedObjectContext
    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    self.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
    //Setup Server currentEventId
    self.serverCurrentEventId = @"currentEventId";
    NSNumber *currentEventId = [[NSNumber alloc] initWithInt:1];
    [Server setCurrentEventId: currentEventId];
    
    //Setup MageServer baseURL
    self.mageServerBaseUrl = @"http://myGpsTest.com";
    NSString * const kBaseServerUrlKey = @"baseServerUrl";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString: self.mageServerBaseUrl];
    [defaults setObject:[url absoluteString] forKey:kBaseServerUrlKey];

}

- (void)tearDown {
    self.managedObjectContext = nil;
    [MagicalRecord cleanUp];
    [OHHTTPStubs removeAllStubs];
    
    [super tearDown];
}

- (void)testGpsLocationForLocation {
    // Arrange - Single test location
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:-1.0 longitude:1.0];
    
    //Act
    [GPSLocation gpsLocationForLocation:testLocation inManagedObjectContext:self.managedObjectContext];
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    //Assert
    XCTAssertFalse(self.managedObjectContext.hasChanges,"All the changes should be saved.");
    NSArray *gpsLocations = [GPSLocation MR_findAllSortedBy:@"timestamp" ascending:YES inContext:self.managedObjectContext];
    XCTAssertEqual(gpsLocations.count, 1, @"Only one GPSLocation should be saved.");
    GPSLocation *fetchedLocation = gpsLocations[0];
    GeoPoint *fetchedPoint = fetchedLocation.geometry;
    XCTAssertEqual(fetchedPoint.location.coordinate.latitude, testLocation.coordinate.latitude,  @"Latitude should be unchanged after saving.");
    XCTAssertEqual(fetchedPoint.location.coordinate.longitude, testLocation.coordinate.longitude,  @"Longitude should be unchanged after saving.");
}

- (void)testFetchGPSLocationsInManagedObjectContext {
    //Arrange - Single test location
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:-1.0 longitude:1.0];
    [GPSLocation gpsLocationForLocation:testLocation inManagedObjectContext:self.managedObjectContext];
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    //Act
    NSArray *gpsLocations = [GPSLocation fetchGPSLocationsInManagedObjectContext:self.managedObjectContext];

    //Assert
    XCTAssertFalse(self.managedObjectContext.hasChanges,"All the changes should be saved.");
    NSArray *testGpsLocations = [GPSLocation MR_findAllSortedBy:@"timestamp" ascending:YES inContext:self.managedObjectContext];
    XCTAssertEqual(gpsLocations.count, testGpsLocations.count, @"GPSLocations fetched should be the same.");
    XCTAssertEqual(gpsLocations.count, 1, @"Only one GPSLocation should be fetched.");
    GPSLocation *fetchedLocation = testGpsLocations[0];
    GeoPoint *fetchedPoint = fetchedLocation.geometry;
    XCTAssertEqual(fetchedPoint.location.coordinate.latitude, testLocation.coordinate.latitude,  @"Latitude should be unchanged after saving.");
    XCTAssertEqual(fetchedPoint.location.coordinate.longitude, testLocation.coordinate.longitude,  @"Longitude should be unchanged after saving.");
}

- (void)testFetchLastXGpsLocations{
    //Arrange - Multiple test locations
    NSDate *dateOne = [NSDate dateWithYear:2016 month:5 day:16 minute:05 second:05];
    NSDate *dateTwo = [NSDate dateWithYear:2016 month:5 day:16 minute:05 second:10];
    NSDate *dateThree = [NSDate dateWithYear:2016 month:5 day:16 minute:05 second:15];
    CLLocation *testLocationOne = [[CLLocation alloc]
                                   initWithCoordinate:CLLocationCoordinate2DMake(-1.0, 1.0)
                                   altitude:0
                                   horizontalAccuracy:0
                                   verticalAccuracy:0
                                   timestamp:dateOne];
    CLLocation *testLocationTwo = [[CLLocation alloc]
                                   initWithCoordinate:CLLocationCoordinate2DMake(1.0, -1.0)
                                   altitude:0
                                   horizontalAccuracy:0
                                   verticalAccuracy:0
                                   timestamp:dateTwo];
    CLLocation *testLocationThree = [[CLLocation alloc]
                                   initWithCoordinate:CLLocationCoordinate2DMake(0.0, 0.0)
                                   altitude:0
                                   horizontalAccuracy:0
                                   verticalAccuracy:0
                                   timestamp:dateThree];
    
    [GPSLocation gpsLocationForLocation:testLocationOne inManagedObjectContext:self.managedObjectContext];
    [GPSLocation gpsLocationForLocation:testLocationTwo inManagedObjectContext:self.managedObjectContext];
    [GPSLocation gpsLocationForLocation:testLocationThree inManagedObjectContext:self.managedObjectContext];
    NSArray *testGpsLocationsInTimeAddedOrder = [NSArray arrayWithObjects:testLocationOne, testLocationTwo, nil];
    NSUInteger fetchLimit = 2;
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    //Act
    NSArray *gpsLocations = [GPSLocation fetchLastXGPSLocations:fetchLimit];

    //Assert
    XCTAssertFalse(self.managedObjectContext.hasChanges,"All the changes should be saved.");
    XCTAssertEqual(gpsLocations.count, testGpsLocationsInTimeAddedOrder.count, @"GPSLocations fetched should be the same.");
    XCTAssertEqual(gpsLocations.count, fetchLimit, @"%lu GPSLocations should be fetched, not %lu.", (unsigned long)fetchLimit, (unsigned long)gpsLocations.count);
    
    NSUInteger counter = 0;
    for (GPSLocation *location in gpsLocations) {
        GeoPoint *point = location.geometry;
        CLLocation *testLocation = testGpsLocationsInTimeAddedOrder[counter];
        counter = counter + 1;
        NSLog(@"%f %f", point.location.coordinate.latitude, testLocation.coordinate.latitude);
        NSLog(@"%f %f", point.location.coordinate.longitude, testLocation.coordinate.longitude);
        XCTAssertEqual(point.location.coordinate.latitude, testLocation.coordinate.latitude,  @"Latitude should be unchanged after saving.");
        XCTAssertEqual(point.location.coordinate.longitude, testLocation.coordinate.longitude,  @"Longitude should be unchanged after saving.");
    }
}

- (void)testOperationToPushGpsLocations {
    //Arrange
    NSDate *dateOne = [NSDate dateWithYear:2016 month:5 day:16 minute:05 second:05];
    NSDate *dateTwo = [NSDate dateWithYear:2016 month:5 day:16 minute:05 second:10];
    CLLocation *testLocationOne = [[CLLocation alloc]
                                   initWithCoordinate:CLLocationCoordinate2DMake(-1.0, 1.0)
                                   altitude:0
                                   horizontalAccuracy:0
                                   verticalAccuracy:0
                                   timestamp:dateOne];
    CLLocation *testLocationTwo = [[CLLocation alloc]
                                   initWithCoordinate:CLLocationCoordinate2DMake(1.0, -1.0)
                                   altitude:0
                                   horizontalAccuracy:0
                                   verticalAccuracy:0
                                   timestamp:dateTwo];
   
    GPSLocation *testGpsLocationOne = [GPSLocation gpsLocationForLocation:testLocationOne inManagedObjectContext:self.managedObjectContext];
    GPSLocation *testGpsLocationTwo = [GPSLocation gpsLocationForLocation:testLocationTwo inManagedObjectContext:self.managedObjectContext];
    NSArray *testGpsLocations = [NSArray arrayWithObjects:testGpsLocationOne, testGpsLocationTwo, nil];
    NSError *error = nil;
    [self.managedObjectContext save:&error];
    
    
    static const NSTimeInterval kResponseTimeTolerence = 10.0;
    static const NSTimeInterval kRequestTime = 0.05;
    static const NSTimeInterval kResponseTime = 0.1;
    
    NSData* expectedResponse = [NSStringFromSelector(_cmd) dataUsingEncoding:NSUTF8StringEncoding];
    NSString *testUrl = @"http://myGpsTest.com/api/events/1/locations";
    
    [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
        //This gets called twice for some reason
        NSLog(@"stubRequest");
        return [request.URL.absoluteString isEqualToString: testUrl];
    } withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
        NSLog(@"stubResponse");
        //return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFile(@"wsresponse.json",self.class) statusCode:200 headers:@{@"Content-Type":@"application/json"}];
        NSDictionary* obj = @{ @"key1": @"value1", @"key2": @[@"value2A", @"value2B"] };
        return [OHHTTPStubsResponse responseWithJSONObject:obj statusCode:200 headers:nil];
    }];
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"OperationToPushGpsLocations request finished"];
    __block __strong id response = nil;
    
    //Act
    NSOperation *locationPushOperation = [GPSLocation operationToPushGPSLocations:testGpsLocations success:^{
        NSLog(@"Success to push GPS locations to the server");
        response = expectedResponse;
        [expectation fulfill];
    } failure:^(NSError *failure){
        XCTFail(@"Failure to push GPS locations to the server in \"%s\" : %@, %@", __PRETTY_FUNCTION__, failure, [failure userInfo]);
        [expectation fulfill];
    }];
    [[HttpManager singleton].manager.operationQueue addOperation:locationPushOperation];

    //Assert
    [self waitForExpectationsWithTimeout:kRequestTime + kResponseTime + kResponseTimeTolerence handler:nil];
    XCTAssertEqualObjects(response, expectedResponse, @"Unexpected data received");
}


@end
