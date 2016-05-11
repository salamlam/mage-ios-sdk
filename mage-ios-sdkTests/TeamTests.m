//
//  TeamTests.m
//  mage-ios-sdk
//

#import <XCTest/XCTest.h>
#import "Team.h"
#import "User.h"


@interface TeamTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;

@end

@implementation TeamTests

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


- (void)testInsertTeamForJson {

    NSString *hardcodedJson = @"{'teams': [{'name': 'Test','description': 'This team belongs specifically to event 'Test' and cannot be deleted.','teamEventId': 35,'userIds': ['987654321'],'id': '123456789'} ]}';'}";
    NSData *jsonData = [hardcodedJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    //Team *testTeam = [Team init];
    [Team insertTeamForJson:dictionary inManagedObjectContext:self.managedObjectContext];
    
    //User *user = [User MR_findFirstByAttribute:@"remoteId" withValue:userId inContext:self.managedObjectContext];
    
    if (![self.managedObjectContext save:&error]) {
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
    XCTAssertFalse(self.managedObjectContext.hasChanges,"All the changes should be saved.");
    
}

@end
