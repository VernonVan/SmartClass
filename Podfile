platform :ios, '9.0'

target 'SmartClass' do
use_frameworks!

pod 'RxSwift',    '~> 3.0'
pod 'RxCocoa',    '~> 3.0'

pod 'RealmSwift'

pod "GCDWebServer/WebUploader", "~> 3.0"
pod 'Reachability', '~> 3.2'

pod 'Toast', '~> 3.0'
pod 'Charts'
pod 'DZNEmptyDataSet', '~> 1.7.3'
pod 'IQKeyboardManager', '~> 4.0.7'

pod 'VideoCore', '~> 0.3.2'

end

post_install do |installer|
installer.pods_project.targets.each do |target|
target.build_configurations.each do |config|
config.build_settings['SWIFT_VERSION'] = '3.0' # or '3.0'
end
end
end
