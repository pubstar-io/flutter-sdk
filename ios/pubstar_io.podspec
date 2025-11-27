#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint pubstar_io.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'pubstar_io'
  s.version          = '1.3.1'
  s.summary          = 'PubStar Mobile AD SDK'
  s.description      = <<-DESC
PubStar Flutter AD SDK helps developers easily integrate ads into Flutter apps.
                       DESC
  s.homepage         = 'https://pubstar.io/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Pubstar' => 'support@pubstar.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_versions = ['5.3']

  # If your plugin requires a privacy manifest, for example if it uses any
  # required reason APIs, update the PrivacyInfo.xcprivacy file to describe your
  # plugin's privacy impact, and then uncomment this line. For more information,
  # see https://developer.apple.com/documentation/bundleresources/privacy_manifest_files
  # s.resource_bundles = {'pubstar_io_privacy' => ['Resources/PrivacyInfo.xcprivacy']}

  # Setup frameworks load frameworks from local
  # s.vendored_frameworks = 'Frameworks/Pubstar.xcframework'
  # s.pod_target_xcconfig = {
  #   'FRAMEWORK_SEARCH_PATHS' => '$(PODS_ROOT)/../../Frameworks'
  # }

  s.static_framework = true
  s.dependency 'Pubstar', '~> 1.3.1'

end
