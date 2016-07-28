//
//  ObservationTests.m
//  mage-ios-sdk
//
//

#import "TestBase.h"
#import "Observation.h"
#import "MageEnums.h"
#import "Attachment.h"
#import "GeoPoint.h"
#import "Server.h"
#import "OHHTTPStubs.h"
#import <OHHTTPStubs/OHHTTPStubsResponse+JSON.h>
#import <OHHTTPStubs/OHPathHelpers.h>
#import "HttpManager.h"


@interface ObservationTests : TestBase
@property (nonatomic,retain) NSString *mageServerBaseUrl;
@property (nonatomic, retain) NSString *serverCurrentEventId;
@property (nonatomic, retain) NSDictionary *json;
@end

@interface Observation (Tests)
+ (NSString *) observationIdFromJson:(NSDictionary *) json;
+ (State) observationStateFromJson:(NSDictionary *) json;
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
  
    //Setup Server currentEventId
    self.serverCurrentEventId = @"currentEventId";
    NSNumber *currentEventId = [[NSNumber alloc] initWithInt:1];
    [Server setCurrentEventId: currentEventId];

    //Setup MageServer baseURL
    self.mageServerBaseUrl = @"http://myObservationTest.com";
    NSString * const kBaseServerUrlKey = @"baseServerUrl";
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSURL *url = [NSURL URLWithString: self.mageServerBaseUrl];
    [defaults setObject:[url absoluteString] forKey:kBaseServerUrlKey];

    //Setup Json Test Data
    NSString *file = @"ObservationTests.geojson";
    NSString *jsonPath  = [[[NSBundle bundleForClass:[ObservationTests class]] resourcePath] stringByAppendingPathComponent:file];
    NSData *jsonObject = [[NSFileManager defaultManager] contentsAtPath:jsonPath];
    NSError *error = nil;
    self.json = [NSJSONSerialization JSONObjectWithData:jsonObject options:0 error:&error];
    
}

- (void)tearDown {

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
    NSString *idValue = @"id";
    NSString *expectedResult = [self.json objectForKey:idValue];
    
    //Act
    NSString *idResult = [Observation observationIdFromJson:self.json];

    //Assert
    XCTAssertEqual(idResult, expectedResult, @"Id should be unchanged when retrieved.");
}

- (void)testObservationStateFromJson {
    //Arrange
    NSString *stateValue = @"state";
    NSString *nameValue = @"name";
    NSDictionary *states = [self.json objectForKey:stateValue];
    NSString *stateResult = [states objectForKey:nameValue];
    State expectedResult = [stateResult StateEnumFromString];
    
    //Act
    State stateActualResult = [Observation observationStateFromJson:self.json];
    
    //Assert
    XCTAssertEqual(stateActualResult, expectedResult, @"State should be unchanged when retrieved.");
}

- (void)testTransientAttachments {
    //Arrange
    NSMutableArray *expectedEmptyResult = [NSMutableArray array];
    NSMutableArray *expectedSingleResult = [NSMutableArray array];
    Observation *observationEmpty = [Observation alloc];
//    Observation *observationSingle = [[Observation alloc] init];
//    Attachment *single = [Attachment attachmentForJson:self.json inContext:self.managedObjectContext];
//    [observationSingle addTransientAttachment:single];
    
    //Act
    NSMutableArray *actualEmptyResult = [observationEmpty transientAttachments];
   // NSMutableArray *actualSingleResult = [observationSingle transientAttachments];
    
    //Assert
    XCTAssertEqual(actualEmptyResult.count, expectedEmptyResult.count, @"Transient Attachement should be empty when initialized.");
  //  XCTAssertEqual(actualSingleResult.count, expectedSingleResult.count, @"Transient Attachement should contain a single object.");
    
}
//
//- (void)testFieldNameToField {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testCreateJsonToSubmit {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testAddTransientAttachment {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testPopulateObjectFromJson {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testGeneratePropertiesFromRaw {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testLocation {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testSectionName {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testOperationToPushObservation {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testOperationToPullObservationsWithSuccess {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
//- (void)testFetchLastObservationDate {
//    //Arrange
//    //Act
//    //Assert
//    XCTFail("Not Implemented");
//}
//
@end
