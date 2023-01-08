source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'
use_frameworks!
inhibit_all_warnings!

target 'IOSHub' do

  # pod 'HiIOS', :path => '../HiIOS'
  pod 'HiIOS', '1.1.0'

  # Base
  pod 'RxOptional', '5.0.2'
  pod 'RxSwiftExt', '6.0.1'
  pod 'RxGesture', '4.0.4'
  pod 'RxViewController', '2.0.0'
  pod 'IQKeyboardManagerSwift', '6.5.10'
  pod 'ReusableKit-Hi/RxSwift', '3.0.0-v4'
  pod 'DefaultsKit', '0.2.0'
  pod 'R.swift', '6.1.0'
  pod 'SwiftLint', '0.50.3'
  pod 'Umbrella/Core', '0.12.0'
  pod 'SnapKit', '5.6.0'
  
  # Advanced
  pod 'MXParallaxHeader', '1.1.0'
  pod 'Parchment', '3.2.0'
  pod 'TagListView', '1.4.1'
  pod 'SwiftSVG', '2.3.2'
  pod 'Toast-Swift', '5.0.1'
  pod 'SwiftEntryKit', '2.0.0'
  pod 'TTTAttributedLabel', '2.0.0'
  pod 'DateToolsSwift-JX', '5.0.0-jx3'
  
  # Platform
  # pod 'MLeaksFinder', '1.0.0'
  # pod 'FLEX', '3.0.0'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
    end
end
