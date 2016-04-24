//
//  mage_ios_sdkTests.m
//  mage-ios-sdkTests
//
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#import "LocalAuthentication.h"

#import "TRVSMonitor.h"

#import <OHHTTPStubs/OHHTTPStubs.h>
#import "OHHTTPStubsResponse+JSON.h"
#import "UserUtility.h"

@interface AuthenticationTests : XCTestCase
//<Authentication> {
	@property User *user;
	@property TRVSMonitor *loginMonitor;
	@property id<Authentication> authentication;
//}

@end

@implementation AuthenticationTests

- (void)setUp {
	[super setUp];
	
	self.loginMonitor = [TRVSMonitor monitor];
	
    self.authentication = [Authentication authenticationModuleForType:[Authentication authenticationTypeFromString:@"LOCAL"]];
	//authentication.delegate = self;
}

- (void)tearDown {
	[super tearDown];
}


//- (void)testLoginSuccess {
//
//	NSLog(@"Running login test");
//	
//	NSString *uid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//	
//	NSDictionary *responseJSON = @{
//		@"token": @"12345",
//		@"user" : @{
//			@"username" : @"test",
//			@"firstname" : @"Test",
//			@"lastname" : @"Test",
//			@"email" : @"test@test.com",
//			@"phones": @[@"333-111-4444", @"444-555-6767"]
//		}
//	};
//	
//	[OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
//		return [request.URL.absoluteString isEqualToString:@"https://mage.geointapps.org/api/login"];
//	} withStubResponse:^OHHTTPStubsResponse*(NSURLRequest *request) {
//		OHHTTPStubsResponse *response = [OHHTTPStubsResponse responseWithJSONObject:responseJSON statusCode:200 headers:@{@"Content-Type":@"application/json"}];
//		return response;
//	}];
//	
//	NSDictionary *parameters =[[NSDictionary alloc] initWithObjectsAndKeys: @"test", @"username", @"12345", @"password", uid, @"uid", nil];
//	
//	[self.authentication loginWithParameters:parameters complete:nil];
//
//	[self.loginMonitor waitWithTimeout:5000];
//	
//	XCTAssertNotNil(self.user, @"'user' object is nil, login was unsuccessful");
//	XCTAssertEqualObjects(self.user.username, @"test", @"username was not set correctly");
////	XCTAssertEqualObjects(user.firstName, @"Test", @"firstname was not set correctly");
////	XCTAssertEqualObjects(user.lastName, @"Test", @"lastname was not set correctly");
//	XCTAssertEqualObjects(self.user.email, @"test@test.com", @"email was not set correctly");
////	XCTAssertEqualObjects(user.phoneNumbers, ([[NSArray alloc] initWithObjects:@"333-111-4444", @"444-555-6767", nil]), @"phone numbers not set correctly");
//}

- (void) authenticationWasSuccessful:(User *)token {
	self.user = token;
	
	[self.loginMonitor signal];
}
- (void) authenticationHadFailure {
	[self.loginMonitor signal];
	
}

@end

