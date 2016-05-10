//
//  GPSLocation+helperTests.m
//  mage-ios-sdk
//

#import <XCTest/XCTest.h>
#import "GPSLocation.h"
#import "OCMockito.h"


#import "Team.h"

@interface GPSLocation_helperTests : XCTestCase
@property (nonatomic,retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation GPSLocation_helperTests

- (void)setUp {
    [super setUp];

    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    //NSManagedObjectContext *defaultContext
    self.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
    
//    
//    // mainBundle is searched when specifying nil
//    NSManagedObjectModel *managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
//    //[NSManagedObjectModel MR_mergedObjectModelFromMainBundle];
//    
//    NSPersistentStoreCoordinator *persistantStoreCoordinate = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
//    
//    
//  //  NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"mage-ios-sdk 7" withExtension:@"momd"];
//  //  NSManagedObjectModel *managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
//  //  NSPersistentStoreCoordinator *persistantStoreCoordinate = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
//    
//    
//    
//    XCTAssertTrue([persistantStoreCoordinate addPersistentStoreWithType:NSInMemoryStoreType configuration:nil URL:nil options:nil error:NULL] ? YES : NO, @"Verify ability to add in-memory store.");
//    self.managedObjectContext = [[NSManagedObjectContext alloc] init];
//    self.managedObjectContext.persistentStoreCoordinator = persistantStoreCoordinate;
//    
//    
    
}

- (void)tearDown {
    
    self.managedObjectContext = nil;
    [MagicalRecord cleanUp];
    
    [super tearDown];
}

- (void)testGpsLocationForLocation {
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:-1.0 longitude:1.0];
  
    
    [GPSLocation gpsLocationForLocation:location inManagedObjectContext:self.managedObjectContext];
   
    
    
    
    //Example *newExample = [NSEntityDescription insertNewObjectForEntityForName:@"Example" inManagedObjectContext:self.moc];
    //newInvoice.dueDate = [NSDate date];
    //NSString* title = [[NSString alloc] initWithFormat:@"Example %@", @123];
    //newExample.title = title;
    
    // Save the context.
    NSError *error = nil;
    if (![self.managedObjectContext save:&error]) {
        XCTFail(@"Error saving in \"%s\" : %@, %@", __PRETTY_FUNCTION__, error, [error userInfo]);
    }
    XCTAssertFalse(self.managedObjectContext.hasChanges,"All the changes should be saved.");
    
    
    
}



- (void)testInsertTeamForJson {
    //Move this to a separate class
    
    
    
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
