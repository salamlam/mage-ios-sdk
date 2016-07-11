//
//  ObservationTests.m
//  mage-ios-sdk
//
//

#import <XCTest/XCTest.h>
#import "Observation.h"
#import "GeoPoint.h"
#import "Server.h"
#import "OHHTTPStubs.h"
#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "HttpManager.h"


@interface ObservationTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic,retain) NSString *mageServerBaseUrl;
@property (nonatomic, retain) NSString *serverCurrentEventId;
@end

@implementation NSData (Tests)

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

@implementation ObservationTests

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
    self.mageServerBaseUrl = @"http://myObservationTest.com";
    NSString * const kBaseServerUrlKey = @"baseServerUrl";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString: self.mageServerBaseUrl];
    [defaults setObject:[url absoluteString] forKey:kBaseServerUrlKey];}

- (void)tearDown {
    self.managedObjectContext = nil;
    [MagicalRecord cleanUp];
    [OHHTTPStubs removeAllStubs];
    
    [super tearDown];
}

- (void)testObservationWithLocation {
    //Arrange
    CLLocation *testLocation = [[CLLocation alloc] initWithLatitude:-1.0 longitude:1.0];
    GeoPoint *testPoint = [[GeoPoint alloc] initWithLocation:testLocation];
    
    //Act
    Observation *observationResult = [Observation observationWithLocation:testPoint inManagedObjectContext:self.managedObjectContext];
    
    //Assert
    XCTAssertEqual(observationResult.location.coordinate.latitude, testLocation.coordinate.latitude,  @"Latitude should be unchanged after saving.");
    XCTAssertEqual(observationResult.location.coordinate.longitude, testLocation.coordinate.longitude,  @"Longitude should be unchanged after saving.");
}

- (void)testObservationIdFromJson {
    //Arrange
    
    
    NSDictionary *jsonObject = @{@"type": @"Feature",
                                 @"geometry":@[
                                         @{@"type":@"Point"},
                                         @{@"coordinate":@[
                                                   @{@"type":@"Point"},
                                                   @{@"coordinate":@"-1.0"}
                                                   ]}
                                         ],
                                 @"properties":@"stuff"};
    
    
    NSLog(@" JSON = %@",jsonObject);
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject options:NSJSONWritingPrettyPrinted error:nil];
    NSLog(@" JSON DATA \n  %@",[NSString stringWithCString:[jsonData bytes] encoding:NSUTF8StringEncoding]);

    
    
//    {
//        "type": "Feature",
//        "geometry": {
//            "type": "Point",
//            "coordinates": [
//                            -1.0,
//                            1.0
//                            ]
//        },
//        "properties": {
//            "accuracy": 0,
//            "field7": "None",
//            "field8": "",
//            "provider": "manual",
//            "timestamp": "2016-05-26T16:08:25.183Z",
//            "type": "At Venue"
//        },
//        "teamIds": [
//                    "b0589"
//                    ],
//        "userId": "67b1b",
//        "deviceId": "547e3ea",
//        "lastModified": "2016-07-05T13:11:42.678Z",
//        "__v": 0,
//        "attachments": [],
//        "id": "7e3e814",
//        "eventId": 1,
//        "url": "https://myObservationTest.com/api/events/1/observations/7e3e814",
//        "state": {
//            "name": "archive",
//            "userId": "5751be",
//            "id": "9496c6",
//            "url": "https://myObservationTest.com/api/events/1/observations/7e3e814/states/9496c6"
//        }
//    }
    
    
    
    
    
    //Act
    //Assert
}

- (void)testObservationStateFromJson {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testTransientAttachments {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testFieldNameToField {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testCreateJsonToSubmit {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testAddTransientAttachment {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testPopulateObjectFromJson {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testGeneratePropertiesFromRaw {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testLocation {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testSectionName {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testOperationToPushObservation {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testOperationToPullObservationsWithSuccess {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

- (void)testFetchLastObservationDate {
    //Arrange
    //Act
    //Assert
    XCTFail("Not Implemented");
}

@end
