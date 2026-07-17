Pod::Spec.new do |spec|
  spec.name             = 'SlotReelKit'
  spec.version          = '1.0.0'
  spec.summary          = 'A high-performance, customizable slot-machine reel view for iOS.'
  spec.description      = <<-DESC
    SlotReelKit provides UIKit and SwiftUI components for building slot-machine style
    reel grids with circular scrolling, staggered column animation, and precise stop control.
    It uses CADisplayLink-driven rendering to avoid blank frames during fast scrolling.
    (SlotReelKit 提供了用于构建老虎机风格卷轴网格的 UIKit 和 SwiftUI 组件，支持循环滚动、错位列动画以及精确的停止控制。它采用 CADisplayLink 驱动的渲染方式，可避免快速滚动时出现空白帧。)
  DESC
  spec.homepage         = 'https://github.com/inmine/SlotReelKit'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'inmine' => '287916135.com' }
  spec.source           = { :git => 'https://github.com/inmine/SlotReelKit.git', :tag => spec.version.to_s }
  spec.platform         = :ios, '16.0'
  spec.swift_version    = '5.9'
  spec.source_files     = 'SlotReelKit/**/*.swift'
  spec.frameworks       = 'UIKit', 'SwiftUI', 'Combine', 'QuartzCore'
end
