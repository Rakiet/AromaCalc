# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'E-somke' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for E-somke

pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Database'
pod 'SVProgressHUD'
pod 'ChameleonFramework/Swift', :git => 'https://github.com/wowansm/Chameleon.git', :branch => 'swift5'

end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end
