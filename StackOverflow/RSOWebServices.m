//
//  RSOWebServices.m
//  StackOverflow
//
//  Created by Howard Vining on 10/31/13.
//  Copyright (c) 2013 Big Nerd Ranch. All rights reserved.
//

#import "RSOWebServices.h"
#import "ReactiveCocoa.h"

NSString *const RSOWebServicesBodyFilter = @"body";
NSString *const RSOWebServicesBodyANDAnswersFilter = @"_ba";
NSString *const RSOWebServicesSort = @"desc";
NSString *const RSOWebServicesSortType = @"hot";
NSString *const RSOErrorDomain = @"RSOErrorDomain";
NSInteger const RSOErrorCode = -42;

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
        sharedService.client = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                             delegate:sharedService
                                                        delegateQueue:nil];
        sharedService.baseUrl = [NSURL URLWithString:@"http://api.stackexchange.com/2.1/"];
        sharedService.baseSite = @"stackoverflow";
    }
    
    return sharedService;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    return [self sharedServices];
}

- (RACSignal *)fetchQuestionsWithTag:(NSString *)tag
{
    NSString *relativeUrl = [self createRelativeURLWithTag:tag];
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        NSURL  *fetchQuestionURL = [NSURL URLWithString:relativeUrl relativeToURL:self.baseUrl];
        NSURLSessionDataTask *task = [self.client dataTaskWithURL:fetchQuestionURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error)
            {
                [subscriber sendError:error];
            }
            else if(!data)
            {
                NSDictionary *userInfo = @{NSLocalizedDescriptionKey: @"No data was received from the server."};
                NSError *dataError = [NSError errorWithDomain:RSOErrorDomain code:RSOErrorCode userInfo:userInfo];
                [subscriber sendError: dataError];
            }
            else
            {
                NSError *jsonError;
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                
                if(jsonError)
                {
                    [subscriber sendError:jsonError];
                }
                else
                {
                    [subscriber sendNext:dict[@"items"]];
                    [subscriber sendCompleted];
                }
            }
        }];
        
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
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
            [task cancel];
        }];
    }];
    
    return signal;
}

- (NSString *)createRelativeURLWithTag:(NSString *)tag
{
    NSString *relativeUrl = [NSString stringWithFormat:@"questions/?site=%@&order=%@&sort=%@%@",
                                     self.baseSite,
                                     RSOWebServicesSort,
                                     RSOWebServicesSortType,
                                     tag ? [NSString stringWithFormat:@"&tagged=%@", tag] : @""];
    
    return relativeUrl;
}
@end
