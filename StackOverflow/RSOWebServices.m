//
//  RSOWebServices.m
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOWebServices.h"
#import "ReactiveCocoa.h"
#import "AFNetworking.h"


NSString *const RSOWebServicesBodyFilter = @"body";
NSString *const RSOWebServicesBodyANDAnswersFilter = @"_ba";
NSString *const RSOWebServicesSort = @"desc";
NSString *const RSOWebServicesSortType = @"hot";

@interface RSOWebServices ()
@property (nonatomic, copy) NSURL *baseUrl;
@property (nonatomic, copy) NSString *baseSite;
@property (nonatomic, copy) NSURLSession *client;
@end

@implementation RSOWebServices

+ (RSOWebServices *)sharedServices
{
    static RSOWebServices *sharedService = nil;
    if(!sharedService)
    {
        sharedService = [[super allocWithZone:nil] init];
        sharedService.client = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:sharedService delegateQueue:nil];
        sharedService.baseUrl = [NSURL URLWithString:@"http://api.stackexchange.com/2.1/"];
        sharedService.baseSite = @"stackoverflow";
    }
    
    return sharedService;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedServices];
}

- (RACSignal *)fetchQuestionsWithQuery:(NSString *)query
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSString *relativeUrl = [NSString stringWithFormat:@"questions/?site=%@&order=%@&sort=%@", self.baseSite, RSOWebServicesSort, RSOWebServicesSortType];
        NSURL  *fetchQuestionURL = [NSURL URLWithString:relativeUrl relativeToURL:self.baseUrl];
        NSURLSessionDataTask *task = [self.client dataTaskWithURL:fetchQuestionURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            [subscriber sendNext:dict[@"items"]];
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    
    return signal;
}

- (RACSignal *)fetchQuestionWithID:(NSUInteger)questionID
{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSString *relativeUrl = [NSString stringWithFormat:@"questions/%d/?site=%@&filter=%@", questionID, self.baseSite, RSOWebServicesBodyANDAnswersFilter];
        NSURL *fetchQuestionURL = [NSURL URLWithString:relativeUrl relativeToURL:self.baseUrl];
        NSURLSessionDataTask *task = [self.client dataTaskWithURL:fetchQuestionURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            [subscriber sendNext:dict[@"items"]];
        }];
        [task resume];
        return [RACDisposable disposableWithBlock:^{
        }];
    }];
    
    return signal;
}

- (void)fetchAnswerWithId:(NSUInteger)answerID completion:(void (^)(NSArray *, NSError *))completion
{
    completion = [completion copy];
    NSString *relativeUrl = [NSString stringWithFormat:@"/answer/%d/?site=%@", answerID , self.baseSite];
    NSURL  *fetchQuestionURL = [NSURL URLWithString:relativeUrl relativeToURL:self.baseUrl];
    [self.client dataTaskWithURL:fetchQuestionURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSAssert(response, @"Should have received a response.");
        
        
    }];
}

- (void)fetchCommentWithId:(NSUInteger)commentID completion:(void (^)(RSOComment *, NSError *))completion
{
    completion = [completion copy];
    NSString *relativeUrl = [NSString stringWithFormat:@"/comment/%d/?site=%@", commentID , self.baseSite];
    NSURL  *fetchQuestionURL = [NSURL URLWithString:relativeUrl relativeToURL:self.baseUrl];
    [self.client dataTaskWithURL:fetchQuestionURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSAssert(response, @"Should have received a response.");
        
        
    }];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler
{
    NSLog(@"Received response: %@", response);
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    NSLog(@"Expected data length: %lu",(unsigned long)totalBytesExpectedToWrite);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data
{
    NSLog(@"Data received: %lu",(unsigned long)data.length);
}
@end
