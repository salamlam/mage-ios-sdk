//
//  TestBase.h
//  mage-ios-sdk
//


#import <XCTest/XCTest.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>

@interface TestBase : XCTestCase
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic) dispatch_group_t dispatchGroup;

@end