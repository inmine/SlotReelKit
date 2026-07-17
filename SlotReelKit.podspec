Pod::Spec.new do |spec|
  spec.name             = 'SlotReelKit'
  spec.version          = '1.0.0'
  spec.summary          = 'A high-performance, customizable slot-machine reel view for iOS.'
  spec.description      = <<-DESC
    SlotReelKit provides UIKit and SwiftUI components for building slot-machine style
    reel grids with circular scrolling, staggered column animation, and precise stop control.
    It uses CADisplayLink-driven rendering to avoid blank frames during fast scrolling.
  DESC
  spec.homepage         = 'https://github.com/your-org/SlotReelKit'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'MGC Team' => 'dev@example.com' }
  spec.source           = { :git => 'https://github.com/your-org/SlotReelKit.git', :tag => spec.version.to_s }
  spec.platform         = :ios, '16.0'
  spec.swift_version    = '5.9'
  spec.source_files     = 'SlotReelKit/**/*.swift'
  spec.frameworks       = 'UIKit', 'SwiftUI', 'Combine', 'QuartzCore'
end
