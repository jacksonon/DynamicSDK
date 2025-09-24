# DynamicSDK Demo App

该示例工程使用 XcodeGen 描述，依赖已经构建好的 `DynamicSDK.xcframework`。运行步骤：

1. 先在仓库根目录执行 `./Scripts/build_xcframework.sh`，确保 `BuildArtifacts/DynamicSDK.xcframework` 存在；
2. 进入当前目录，运行 `xcodegen generate` 生成 `DynamicSDKDemo.xcodeproj`；
3. 使用 Xcode 打开工程，选择目标设备后直接运行即可。

示例应用会：

- 通过 `DYKImageLoader` 加载 Unsplash 图片；
- 使用 `DYKNetworkManager` 请求公开 JSON 接口；
- 演示如何直接调用 `AFNetworkReachabilityManager` 与 `SDImageCache` 等原第三方 API。
