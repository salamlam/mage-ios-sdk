//
//  TestBase.m
//  mage-ios-sdk
//
//  Created by Chris Wasko on 7/27/16.
//  Copyright © 2016 National Geospatial-Intelligence Agency. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestBase.h"

@implementation TestBase

- (void)setUp {
    [super setUp];

    //Setup in-memory MagicalRecord ManagedObjectContext
    [MagicalRecord setDefaultModelFromClass:[self class]];
    [MagicalRecord setupCoreDataStackWithInMemoryStore];
    
    self.managedObjectContext = [NSManagedObjectContext MR_defaultContext];
//    
//    if (self.dispatchGroup == nil) {
//        self.dispatchGroup = dispatch_group_create();
//    }
}

- (void)tearDown {
  //  [self waitForGroup];
    [MagicalRecord cleanUp];
    self.managedObjectContext = nil;
    self.dispatchGroup = nil;
    [super tearDown];
}

- (void)waitForGroup {
    //dispatch_group_enter(self.dispatchGroup);
    //[self.managedObjectContext performBlock:^{
    //
    //    dispatch_group_leave(self.dispatchGroup);
    //}];
    
    __block BOOL didComplete = NO;
    dispatch_group_notify(self.dispatchGroup, dispatch_get_main_queue(), ^{
        didComplete = YES;
    });
    
    while (!didComplete) {
        NSTimeInterval const interval = 0.002;
        if (! [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:interval]]) {
            [NSThread sleepForTimeInterval:interval];
        }
    }
}



@end