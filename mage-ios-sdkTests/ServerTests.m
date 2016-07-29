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
    [super tearDown];
}

- (void)testSetProperty {
    //Arrange
    
    //Act
    //[Server setProperty:<#(id)#> forKey:<#(NSString *)#> completion:<#^(BOOL contextDidSave, NSError * _Nullable error)completion#>];
    
    //Assert
    
}

- (void)testGetPropertyForKey {
    //Arrange
    //Act
    //Assert
}

@end
