#import "ViewController.h"
#import <DynamicSDK/DynamicSDK.h>

@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *statusLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"DynamicSDK %@", DYKDynamicSDKVersion()];
    self.view.backgroundColor = UIColor.systemBackgroundColor;

    [self buildInterface];
    [self demonstrateImageLoading];
    [self demonstrateNetworking];
    [self startReachabilityMonitoring];
}

- (void)buildInterface {
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    self.imageView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];

    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.statusLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.statusLabel.numberOfLines = 0;
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
    self.statusLabel.text = @"准备加载…";

    UIStackView *stack = [[UIStackView alloc] initWithArrangedSubviews:@[self.imageView, self.statusLabel]];
    stack.axis = UILayoutConstraintAxisVertical;
    stack.translatesAutoresizingMaskIntoConstraints = NO;
    stack.spacing = 20.0;

    [self.view addSubview:stack];

    [NSLayoutConstraint activateConstraints:@[
        [stack.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor constant:24.0],
        [stack.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor constant:-24.0],
        [stack.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor],
        [self.imageView.heightAnchor constraintEqualToConstant:220.0]
    ]];
}

- (void)demonstrateImageLoading {
    NSURL *imageURL = [NSURL URLWithString:@"https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e?w=600&q=80"];
    __weak typeof(self) weakSelf = self;
    [[DYKImageLoader sharedLoader] loadImageWithURL:imageURL
                                      intoImageView:self.imageView
                                         placeholder:nil
                                          completion:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                              __strong typeof(weakSelf) strongSelf = weakSelf;
                                              if (!strongSelf) { return; }
                                              if (error) {
                                                  [strongSelf appendStatus:[NSString stringWithFormat:@"图片加载失败: %@", error.localizedDescription]];
                                              } else {
                                                  [strongSelf appendStatus:@"已通过 DynamicSDK 集成的 SDWebImage 成功加载图片。"];
                                              }
                                          }];
}

- (void)demonstrateNetworking {
    NSString *URLString = @"https://jsonplaceholder.typicode.com/todos/1";
    __weak typeof(self) weakSelf = self;
    [[DYKNetworkManager sharedManager] GET:URLString
                                parameters:nil
                                completion:^(id  _Nullable responseObject, NSError * _Nullable error) {
                                    __strong typeof(weakSelf) strongSelf = weakSelf;
                                    if (!strongSelf) { return; }
                                    if (error) {
                                        [strongSelf appendStatus:[NSString stringWithFormat:@"请求失败: %@", error.localizedDescription]];
                                    } else if ([responseObject isKindOfClass:NSDictionary.class]) {
                                        NSDictionary *dictionary = (NSDictionary *)responseObject;
                                        NSString *title = dictionary[@"title"] ?: @"<无标题>";
                                        [strongSelf appendStatus:[NSString stringWithFormat:@"网络请求成功，标题: %@", title]];
                                    } else {
                                        [strongSelf appendStatus:@"收到未知格式的响应。"];
                                    }
                                }];
}

- (void)startReachabilityMonitoring {
    AFNetworkReachabilityManager *reachability = [AFNetworkReachabilityManager sharedManager];
    [reachability setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability changed: %ld", (long)status);
    }];
    [reachability startMonitoring];

    [[SDImageCache sharedImageCache] clearMemory];
}

- (void)appendStatus:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *existing = self.statusLabel.text ?: @"";
        if (existing.length == 0 || [existing isEqualToString:@"准备加载…"]) {
            self.statusLabel.text = message;
        } else {
            self.statusLabel.text = [existing stringByAppendingFormat:@"\n%@", message];
        }
    });
}

@end
