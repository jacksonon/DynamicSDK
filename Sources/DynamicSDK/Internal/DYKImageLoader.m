#import "DYKImageLoader.h"

@implementation DYKImageLoader

+ (instancetype)sharedLoader {
    static DYKImageLoader *loader;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loader = [[self alloc] init];
    });
    return loader;
}

- (void)loadImageWithURL:(NSURL *)url
             intoImageView:(UIImageView *)imageView
                placeholder:(UIImage *)placeholder
                 completion:(SDExternalCompletionBlock)completion {
    if (!imageView || !url) {
        if (completion) {
            NSError *error = [NSError errorWithDomain:@"com.dynamic.sdk.imageloader"
                                                 code:-1
                                             userInfo:@{NSLocalizedDescriptionKey: @"Missing image view or URL."}];
            completion(nil, NO, error, url);
        }
        return;
    }

    [imageView sd_setImageWithURL:url
                  placeholderImage:placeholder
                           options:SDWebImageRetryFailed
                         completed:completion];
}

- (void)prefetchURLs:(NSArray<NSURL *> *)urls {
    if (urls.count == 0) {
        return;
    }
    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:urls];
}

@end
