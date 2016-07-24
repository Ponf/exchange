//
// Created by Филипп Панфилов on 24/07/16.
// Copyright (c) 2016 test. All rights reserved.
//

#import <AFNetworking/AFURLSessionManager.h>
#import <XMLReader/XMLReader.h>
#import "NetworkingService.h"
#import "URLProvider.h"


@implementation NetworkingService {

}

- (void)receiveCurrentExchangeRatesCompleted: (void (^)(BOOL, NSDictionary<NSString *,NSString *> *, NSError *))completed {
    void (^safeCompleted)(BOOL, NSDictionary<NSString *,NSString *> *, NSError *) = ^void(BOOL succeed, NSDictionary<NSString *,NSString *> *rates, NSError *error) {
        if (completed) {
            completed(succeed, rates, error);
        }
    };

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[URLProvider serverUrl]]];
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfiguration];
    AFHTTPResponseSerializer *serializer = [AFHTTPResponseSerializer serializer];
    serializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml"];
    [manager setResponseSerializer:serializer];
    [[manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error == nil) {
            NSError *parseError = nil;
            NSDictionary<NSString *, NSString *> *rates = [self parseResultsFromServerResponse:[XMLReader dictionaryForXMLData:responseObject
                                                                                                                         error:&parseError]];
            if (!parseError) {
                safeCompleted(YES, rates, nil);
            } else {
                safeCompleted(NO, nil, parseError);
            }
        }
        else{
            safeCompleted(NO, nil, error);
        }

    }] resume];
}

- (NSDictionary<NSString *,NSString *> *)parseResultsFromServerResponse:(NSDictionary *)response {
    NSMutableDictionary<NSString *,NSString *> *result = @{}.mutableCopy;
    NSArray *rates = response[@"gesmes:Envelope"][@"Cube"][@"Cube"][@"Cube"];
    [rates enumerateObjectsUsingBlock:^(NSDictionary *item, NSUInteger idx, BOOL *stop) {
        result[item[@"currency"]] = item[@"rate"];
    }];
    result[@"EUR"] = @"1.00";
    return [result copy];
}


@end