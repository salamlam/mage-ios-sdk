//
//  ObservationPushService.m
//  mage-ios-sdk
//
//  Created by Dan Barela on 10/31/14.
//  Copyright (c) 2014 National Geospatial-Intelligence Agency. All rights reserved.
//

#import "ObservationPushService.h"
#import "HttpManager.h"
#import "NSManagedObjectContext+MAGE.h"
#import "Observation+helper.h"

NSString * const kObservationPushFrequencyKey = @"observationPushFrequency";

@interface ObservationPushService ()
@property (nonatomic) NSTimeInterval interval;
@property (nonatomic, strong) NSTimer* observationPushTimer;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSMutableDictionary *pushingObservations;
@end

@implementation ObservationPushService

- (id) init {
    if (self = [super init]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        _interval = [[defaults valueForKey:kObservationPushFrequencyKey] doubleValue];
        _pushingObservations = [[NSMutableDictionary alloc] init];
        
        [[NSUserDefaults standardUserDefaults] addObserver:self
                                                forKeyPath:kObservationPushFrequencyKey
                                                   options:NSKeyValueObservingOptionNew
                                                   context:NULL];
        
        NSManagedObjectContext *context = [NSManagedObjectContext defaultManagedObjectContext];
        
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        [fetchRequest setEntity:[NSEntityDescription entityForName:@"Observation" inManagedObjectContext:context]];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"timestamp" ascending:NO], nil]];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"dirty == YES"]];

        self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                                                   managedObjectContext:context
                                                                                                     sectionNameKeyPath:@"sectionName"
                                                                                                              cacheName:nil];
    }
    
    return self;
}

- (void) start {
    [self stop];
    
    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    [self pushObservations];
}

- (void) scheduleTimer {
    self.observationPushTimer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(onTimerFire) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:self.observationPushTimer forMode:NSRunLoopCommonModes];
}

- (void) onTimerFire {
    [self pushObservations];
}

- (void) pushObservations {
    NSLog(@"currently still pushing %lu observations", (unsigned long)self.pushingObservations.count);
    if (self.pushingObservations.count != 0) return;
    
    for (Observation *observation in [self.fetchedResultsController fetchedObjects]) {
        [self.pushingObservations setObject:observation forKey:observation.objectID];
    }
    
    NSLog(@"about to push %lu observations", (unsigned long)self.pushingObservations.count);
    for (id observationId in self.pushingObservations) {
        Observation *observation = [self.pushingObservations objectForKey:observationId];
        NSLog(@"submitting observation %@", observation.objectID);
        NSOperation *observationPushOperation = [Observation operationToPushObservation:observation success:^{
            NSLog(@"Successfully submitted observation");
            observation.dirty = [NSNumber numberWithBool:NO];
            
            NSError *error;
            if (![[NSManagedObjectContext defaultManagedObjectContext] save:&error]) {
                NSLog(@"Error updating locations: %@", error);
            }
            
            [self.pushingObservations removeObjectForKey:observation.objectID];
        } failure:^{
            NSLog(@"Error submitting observation");
            [self.pushingObservations removeObjectForKey:observation.objectID];
        }];
        
        [[HttpManager singleton].manager.operationQueue addOperation:observationPushOperation];
    }
    // probably not exactly correct but for now i am just going to schedule right here
    // should wait for things to push and then schedule again maybe.
    [self scheduleTimer];
}

-(void) stop {
    if ([_observationPushTimer isValid]) {
        [_observationPushTimer invalidate];
        _observationPushTimer = nil;
        
    }
}

@end
