platform :ios, '9.0'

target 'SmartClass' do
use_frameworks!

pod 'RealmSwift'
pod 'RxSwift',    '~> 3.0'
pod 'RxCocoa',    '~> 3.0'
pod 'VideoCore', '~> 0.3.2'
pod "GCDWebServer/WebUploader", "~> 3.0"

pod 'Charts'
pod 'Toast', '~> 3.0'
pod 'SnapKit', '~> 3.0.2'
pod 'DZNEmptyDataSet', '~> 1.7.3'
pod 'IQKeyboardManager', '~> 4.0.7'

end

post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
end
end
end
