#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <SDWebImage/SDWebImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface DYKImageLoader : NSObject

+ (instancetype)sharedLoader;

- (void)loadImageWithURL:(NSURL *)url
             intoImageView:(UIImageView *)imageView
                placeholder:(nullable UIImage *)placeholder
                 completion:(nullable SDExternalCompletionBlock)completion;

- (void)prefetchURLs:(NSArray<NSURL *> *)urls;

@end

NS_ASSUME_NONNULL_END
