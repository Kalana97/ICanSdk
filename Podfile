#source 'https://github.com/CocoaPods/Specs.git'
source 'https://cdn.cocoapods.org/'
platform :ios, '9.0'
inhibit_all_warnings!
def commondPods
  pod 'AFNetworking'
  pod 'Masonry'
  pod 'CocoaLumberjack'
  pod 'MBProgressHUD'
  pod 'SDWebImage'
  pod 'FLAnimatedImage'
  pod 'MJRefresh'
  pod 'MJExtension'
  pod 'QMUIKit'
  pod 'WCDB'
  pod 'TZImagePickerController'
  pod 'YBImageBrowser'
  pod 'YBImageBrowser/Video'
  pod 'IQKeyboardManager'
  pod 'AliyunOSSiOS'
  #pod 'Bugly'#异常统计
  #pod 'WMPageController'
  pod 'AlipaySDK-iOS', '15.7.9'
  pod 'BRPickerView'
  #pod 'libOpenInstallSDK'
  pod 'TXLiteAVSDK_Player', '9.1.10564'  
  #pod 'WechatOpenSDK_NoPay' #微信sdk
  pod 'WechatOpenSDK_UnPay'
  pod 'YYImage',:git => 'https://github.com/QiuYeHong90/YYImage.git'
  pod 'ReactiveObjC'
  pod 'NERtcSDK', '~> 5.5.2'
  pod 'NIMSDK_LITE'
  pod "CTMediator"
  pod 'FLAnimatedImage'
  pod 'WBGLinkPreview'
  pod 'TFHpple'
  pod 'Firebase/Core'
  pod 'Firebase/Performance'
  pod 'Firebase/Crashlytics'
  pod 'DTCoreText'
end
target 'ICan' do
  commondPods
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["ONLY_ACTIVE_ARCH"] = "YES"
    end
  end
end
