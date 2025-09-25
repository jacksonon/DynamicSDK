#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^DYKNetworkCompletion)(id _Nullable responseObject, NSError * _Nullable error);

typedef NSDictionary<NSString *, NSString *> * DYKHTTPHeaders;

@interface DYKNetworkManager : NSObject

@property (nonatomic, strong, readonly) AFHTTPSessionManager *sessionManager;

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(nullable NSDictionary<NSString *, id> *)parameters
                   completion:(DYKNetworkCompletion)completion;

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(nullable NSDictionary<NSString *, id> *)parameters
                       headers:(nullable DYKHTTPHeaders)headers
                    completion:(DYKNetworkCompletion)completion;

- (void)cancelAllRequests;

@end

NS_ASSUME_NONNULL_END
