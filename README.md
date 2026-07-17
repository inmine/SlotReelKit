# SlotReelKit

**当前版本：1.0.0**

[English](#english) | [中文](#中文)

---

## 中文

SlotReelKit 是一个高性能 iOS 老虎机滚轮组件库，支持 UIKit 与 SwiftUI。  
它使用 **固定 Slot 视图 + 循环取模 + CADisplayLink 逐帧动画**，在快速滚动时不会出现空白帧，也不会像 `UICollectionView` 懒加载那样卡顿或发热。

### 特性

- 支持 3×3 经典老虎机布局，也支持自定义列数 / 行数 / 符号数
- 逐列延迟启动、逐列停止
- 内置严格中奖矩阵生成器（仅一条中奖线）
- 支持传入自定义结果矩阵
- UIKit / SwiftUI 双端接入
- 可配置动画时长、圈数、缓动曲线、外观样式
- 适合后续发布到 CocoaPods

### 安装

#### CocoaPods（本地路径）

```ruby
pod 'SlotReelKit', :path => 'SlotReelKit'
```

#### CocoaPods（远程仓库，发布后可使用）

```ruby
pod 'SlotReelKit', '1.0.0'
```

然后执行：

```bash
pod install
```

### 快速开始（SwiftUI）

```swift
import SlotReelKit
import SwiftUI

struct DemoView: View {
    @StateObject private var engine = SlotReelEngine(
        configuration: .default()
    )

    private let appearance = SlotReelAppearanceConfiguration(
        symbolImageProviderClosure: { index in
            UIImage(named: "symbol_\(index + 1)")
        }
    )

    var body: some View {
        VStack(spacing: 20) {
            SlotReelView(engine: engine, appearance: appearance)

            Button("Spin") {
                engine.startRoll(targetSymbolIndex: 2) {
                    print("Spin finished")
                }
            }
            .disabled(engine.isRolling)
        }
    }
}
```

### 快速开始（UIKit）

```swift
import SlotReelKit

final class DemoViewController: UIViewController {
    private let engine = SlotReelEngine(configuration: .default())
    private var columnViews: [SlotReelColumnView] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let appearance = SlotReelAppearanceConfiguration(
            symbolImageProviderClosure: { index in
                UIImage(named: "symbol_\(index + 1)")
            }
        )

        for column in 0..<engine.configuration.columnCount {
            let columnView = SlotReelColumnView(
                configuration: engine.configuration,
                appearance: appearance,
                animationConfiguration: engine.animationConfiguration
            )
            columnView.setContentOffset(engine.columnOffsets[column], animated: false)
            view.addSubview(columnView)
            columnViews.append(columnView)
        }
    }

    @objc private func spin() {
        engine.startRoll(targetSymbolIndex: 1) { [weak self] in
            print("done")
        }
    }
}
```

### 核心类型

| 类型 | 说明 |
|------|------|
| `SlotReelConfiguration` | 布局配置：列数、行数、尺寸、间距 |
| `SlotReelAnimationConfiguration` | 动画配置：圈数、时长、延迟、缓动 |
| `SlotReelAppearanceConfiguration` | 外观配置：背景色、圆角、图片提供器 |
| `SlotReelEngine` | 滚动引擎，负责 spin 会话与停轮结果 |
| `SlotReelView` | SwiftUI 入口视图 |
| `SlotReelColumnView` | UIKit 单列视图 |
| `SlotReelMatrixGenerator` | 内置严格中奖矩阵生成器 |

### 自定义布局

```swift
let configuration = SlotReelConfiguration(
    columnCount: 3,
    visibleRowCount: 3,
    symbolCount: 6,
    renderBufferRows: 2,
    outerSize: CGSize(width: 320, height: 220),
    gridPadding: 12,
    cellSpacing: 8
)

let animation = SlotReelAnimationConfiguration(
    baseCycleCount: 12,
    cycleIncrementPerColumn: 4,
    columnStartStagger: 0.15,
    baseDuration: 1.8,
    durationIncrementPerColumn: 0.4,
    easing: .easeInOutCubic
)

let engine = SlotReelEngine(
    configuration: configuration,
    animationConfiguration: animation
)
```

### 自定义结果矩阵

```swift
let matrix = SlotReelMatrix(values: [
    [0, 1, 2],
    [1, 2, 3],
    [2, 3, 4]
])

engine.startRoll(resultMatrix: matrix) {
    print("Stopped at custom matrix")
}
```

### 代理回调

```swift
final class ReelCoordinator: SlotReelEngineDelegate {
    func slotReelEngine(_ engine: SlotReelEngine, didStartSpin session: SlotReelSpinSession) {
        print("Spin started")
    }

    func slotReelEngine(_ engine: SlotReelEngine, didStopColumn column: Int, in session: SlotReelSpinSession) {
        print("Column \(column) stopped")
    }

    func slotReelEngine(_ engine: SlotReelEngine, didFinishSpin session: SlotReelSpinSession) {
        print("All columns stopped")
    }
}
```

### 发布到 CocoaPods 的建议步骤

1. 将 `SlotReelKit` 目录单独推送到 Git 仓库
2. 修改 `SlotReelKit.podspec` 中的 `homepage`、`source`、`author`
3. 打 tag，例如 `1.0.0`
4. 执行 `pod lib lint SlotReelKit.podspec`
5. 执行 `pod trunk push SlotReelKit.podspec`

### 系统要求

- iOS 16.0+
- Swift 5.9+
- Xcode 15+

### License

MIT

### 发布指南

如需发布到 CocoaPods / SPM，请阅读 [PUBLISHING.md](./PUBLISHING.md)。

---

## English

SlotReelKit is a high-performance slot-machine reel component for iOS with UIKit and SwiftUI support.

It renders reels using **fixed slot views + circular modulo indexing + CADisplayLink frame animation**, which avoids blank frames during fast scrolling and performs better than lazy `UICollectionView` approaches.

### Features

- Classic 3×3 slot layout with customizable columns, rows, and symbol count
- Staggered column start and sequential stop
- Built-in strict win-line matrix generator
- Custom result matrix support
- UIKit and SwiftUI APIs
- Configurable animation, easing, and appearance
- CocoaPods ready

### Installation

#### CocoaPods（本地路径）

```ruby
pod 'SlotReelKit', :path => 'SlotReelKit'
```

#### CocoaPods（远程仓库）

```ruby
pod 'SlotReelKit', '1.0.0'
```

### SwiftUI Quick Start

```swift
import SlotReelKit

@StateObject private var engine = SlotReelEngine(configuration: .default())

SlotReelView(
    engine: engine,
    appearance: SlotReelAppearanceConfiguration(
        symbolImageProviderClosure: { UIImage(named: "symbol_\($0 + 1)") }
    )
)

engine.startRoll(targetSymbolIndex: 2) {
    print("finished")
}
```

### Main Components

- `SlotReelConfiguration` – layout
- `SlotReelAnimationConfiguration` – timing
- `SlotReelAppearanceConfiguration` – styling and symbol images
- `SlotReelEngine` – spin coordinator
- `SlotReelView` / `SlotReelColumnView` – UI entry points

### Requirements

- iOS 16.0+
- Swift 5.9+

### License

MIT
