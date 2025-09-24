# DynamicSDK 聚合框架

DynamicSDK 是一个示例性的 iOS 动态框架项目，演示如何将多个公开的三方库（当前集成了 [AFNetworking](https://github.com/AFNetworking/AFNetworking) 与 [SDWebImage](https://github.com/SDWebImage/SDWebImage)）聚合到一个可分发的 `.xcframework` 中。该框架自动暴露自身的公共接口，同时将原三方库的头文件复制到最终产物内，保证集成方既可以使用 DynamicSDK 提供的便捷封装，也能直接访问 AFNetworking / SDWebImage 的原生 API。

> **注意**：仓库提供的脚本和 GitHub Action workflow 需要在 macOS + Xcode 环境下执行，当前容器无法直接构建。

## 特性

- ✅ 使用 CocoaPods（静态链接模式）将 AFNetworking 与 SDWebImage 聚合进单一的动态框架目标。
- ✅ 通过 `Scripts/copy_third_party_headers.sh` 自动把第三方公开头文件复制到产物中，对外继续暴露原有 API。
- ✅ 提供 `DYKNetworkManager`、`DYKImageLoader` 等二次封装，演示如何在聚合 SDK 中提供统一接口。
- ✅ 提供完整的打包脚本 `Scripts/build_xcframework.sh` 以及 GitHub Actions CI，自动生成跨架构的 `DynamicSDK.xcframework`。
- ✅ 附带 `Examples/DemoApp` 示例工程，展示集成产物及直接调用 AFNetworking / SDWebImage API 的方法。

## 仓库结构

```
.
├── project.yml                     # XcodeGen 项目描述（框架）
├── Podfile                         # CocoaPods 配置，静态链接第三方依赖
├── Scripts/                        # 自动化脚本
│   ├── bootstrap.sh                # 生成 Xcode 工程并安装 Pods
│   ├── build_xcframework.sh        # 打包 Release 版本的 DynamicSDK.xcframework
│   └── copy_third_party_headers.sh # 在构建产物中同步三方头文件
├── Sources/DynamicSDK/             # 框架源码
│   ├── Public/                     # 对外头文件
│   │   ├── DynamicSDK.h            # 框架总头文件（同时 import 原三方头文件）
│   │   ├── DYKImageLoader.h
│   │   └── DYKNetworkManager.h
│   └── Internal/                   # Objective-C 实现文件
├── Examples/DemoApp/               # 演示 App（同样使用 XcodeGen 生成）
│   ├── project.yml
│   └── Sources/
└── .github/workflows/build.yml     # GitHub Actions CI
```

## 环境要求

- macOS 13 或以上
- Xcode 14.3 或以上
- [Homebrew](https://brew.sh/)（用于安装 XcodeGen）
- Ruby（建议使用系统自带）以及 Bundler

## 快速开始

1. **安装依赖**

   ```bash
   brew install xcodegen
   gem install bundler # 若尚未安装
   ```

2. **生成工程并安装 Pods**

   ```bash
   ./Scripts/bootstrap.sh
   ```

   脚本会执行以下操作：

   - 调用 `xcodegen generate` 根据 `project.yml` 生成 `DynamicSDK.xcodeproj`；
   - 使用 Bundler 安装 CocoaPods；
   - 运行 `pod install` 生成 `DynamicSDK.xcworkspace` 并拉取 AFNetworking / SDWebImage。

3. **打包 `.xcframework`**

   ```bash
   ./Scripts/build_xcframework.sh
   ```

   完成后可在 `BuildArtifacts/DynamicSDK.xcframework` 找到 Release 版本的跨架构二进制（同时包含真机与模拟器 slice）。

4. **运行示例 App**

   - 在 `BuildArtifacts/` 下已生成 `DynamicSDK.xcframework`；
   - 进入 `Examples/DemoApp`，执行 `xcodegen generate` 生成 Demo 工程；
   - 打开生成的 `DynamicSDKDemo.xcodeproj`，使用 Xcode 运行在模拟器或真机上。

   示例应用会演示：

   - 通过 `DYKImageLoader` 加载网络图片；
   - 使用 `DYKNetworkManager` 请求 JSON 接口；
   - 直接访问 `AFNetworkReachabilityManager` / `SDImageCache` 等第三方 API。

## 集成方式

若要在自有项目中使用该聚合框架，可按照如下步骤：

1. 运行 `Scripts/build_xcframework.sh` 获取最新产物；
2. 将 `BuildArtifacts/DynamicSDK.xcframework` 拷贝到目标工程；
3. 在 Xcode 中通过 **Frameworks, Libraries, and Embedded Content** 将该 `.xcframework` 以 "Embed & Sign" 方式引入；
4. 在 Objective-C 中使用 `#import <DynamicSDK/DynamicSDK.h>`，在 Swift 中使用 `import DynamicSDK`；
5. 你可以：
   - 直接使用 `DYKNetworkManager`、`DYKImageLoader` 封装接口；
   - 或者继续调用 `AFNetworking` / `SDWebImage` 原生 API（头文件会随着框架一并分发）。

## GitHub Actions

仓库内置 `.github/workflows/build.yml`，在 push / PR 时自动于 `macos-latest` 环境执行：

1. `./Scripts/bootstrap.sh`
2. `./Scripts/build_xcframework.sh`
3. 上传构建好的 `DynamicSDK.xcframework` 产物至当前 workflow

可根据实际需求扩展发布流程或增加单元测试步骤。

## 许可证与三方声明

本仓库代码以 MIT 许可证开源，详见 [LICENSE](LICENSE)（如需）。

`DynamicSDK` 聚合并重新分发了下列第三方库的头文件与编译产物，请务必遵守它们各自的许可证：

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) — MIT License
- [SDWebImage](https://github.com/SDWebImage/SDWebImage) — MIT License

更多信息可在 [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md) 中查看。
