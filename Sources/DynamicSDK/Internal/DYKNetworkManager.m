#import "DYKNetworkManager.h"

@interface DYKNetworkManager ()
@property (nonatomic, strong, readwrite) AFHTTPSessionManager *sessionManager;
@end

@implementation DYKNetworkManager

+ (instancetype)sharedManager {
    static DYKNetworkManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
        _sessionManager.completionQueue = dispatch_queue_create("com.dynamic.sdk.network", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary<NSString *,id> *)parameters
                   completion:(DYKNetworkCompletion)completion {
    NSParameterAssert(URLString.length > 0);

    NSURLSessionDataTask *task = [self.sessionManager GET:URLString
                                               parameters:parameters
                                                  headers:nil
                                                 progress:nil
                                                  success:^(NSURLSessionDataTask *task, id responseObject) {
                                                      if (completion) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              completion(responseObject, nil);
                                                          });
                                                      }
                                                  }
                                                  failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                      if (completion) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              completion(nil, error);
                                                          });
                                                      }
                                                  }];
    return task;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary<NSString *,id> *)parameters
                       headers:(DYKHTTPHeaders)headers
                    completion:(DYKNetworkCompletion)completion {
    NSParameterAssert(URLString.length > 0);

    NSURLSessionDataTask *task = [self.sessionManager POST:URLString
                                                parameters:parameters
                                                   headers:headers
                                                  progress:nil
                                                   success:^(NSURLSessionDataTask *task, id responseObject) {
                                                       if (completion) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               completion(responseObject, nil);
                                                           });
                                                       }
                                                   }
                                                   failure:^(NSURLSessionDataTask *task, NSError *error) {
                                                       if (completion) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               completion(nil, error);
                                                           });
                                                       }
                                                   }];
    return task;
}

- (void)cancelAllRequests {
    for (NSURLSessionTask *task in self.sessionManager.tasks) {
        [task cancel];
    }
}

@end
