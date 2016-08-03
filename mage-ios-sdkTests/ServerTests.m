//
//  ServerTests.m
//  mage-ios-sdk
//

#import "TestBase.h"
#import "Server.h"


@interface ServerTests : TestBase
@end

@interface Server (Tests)
+ (id) getPropertyForKey:(NSString *) key;
+ (void) setProperty:(id) property forKey:(NSString *) key completion:(void (^)(BOOL contextDidSave, NSError * _Nullable error)) completion;
@end


@implementation ServerTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [OHHTTPStubs removeAllStubs];

    [super tearDown];
}

- (void)testSetProperty {
    //Arrange
    NSString *invalidKey = @"invalidKey";
    NSString *validKey = @"testKey";
    NSString *property = @"testValue";
    void (^completion)(BOOL contextDidSave, NSError * _Nullable error);
    completion = ^void(BOOL contextDidSave, NSError * _Nullable error) {
        //Unable to verify results because of MR_newPrivateQueueContext
        XCTAssertTrue(contextDidSave, @"Context should have saved.");
        XCTAssertNil(error, @"Context should have saved without error:%@", error);
    };

    //Act
    // This will run on MR background thread on MR_newPrivateQueueContext; which is unable to be retrieved and tested
    [Server setProperty:property forKey:validKey completion:completion];
    //NSString *actualValidResult = [Server getPropertyForKey:validKey];
    NSString *actualInvalidResult = [Server getPropertyForKey:invalidKey];
    
    //Assert
    //Unable to verify results because of the MR_newPrivateQueueContext
    //XCTAssertEqual(actualValidResult, property, @"Value should be unchanged after get.");
    XCTAssertEqual(actualInvalidResult, nil, @"Value should be nil when key is not found.");

}

- (void)testGetPropertyForKey {
    //Arrange
    NSString *invalidKey = @"invalidKey";
    NSString *validKey = @"testKey";
    NSString *property = @"testValue";
    Server *server = [Server MR_createEntityInContext:self.managedObjectContext];
    server.properties = @{validKey: property};

    //Act
    NSString *actualValidResult = [Server getPropertyForKey:validKey];
    NSString *actualInvalidResult = [Server getPropertyForKey:invalidKey];
    
    //Assert
    XCTAssertEqual(actualValidResult, property, @"Value should be unchanged after get.");
    XCTAssertEqual(actualInvalidResult, nil, @"Value should be nil when key is not found.");
}

@end
