# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

workspace 'CLLivingDetectWorkspace'
project 'CLLivingDetectionDemo/CLLivingDetectionDemo.xcodeproj'

inhibit_all_warnings!

target 'CLLivingDetectionDemo' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
pod 'Masonry'
pod 'SVProgressHUD'
pod 'MJExtension'
#pod 'Wormholy'
#pod 'CL_ShanYanSDK', '2.3.5.7'
  # Pods for CLLivingDetectionDemo

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
            end
        end
    end
end
