Pod::Spec.new do |s|
  s.name             = 'Pubstar'
  s.version          = '1.3.0'
  s.summary          = 'Pubstar Mobile AD SDK'
  s.homepage         = 'https://pubstar.io/'
  s.license          = { :type => 'Apache-2.0' }
  s.author           = { 'Pubstar' => 'support@pubstar.io' }
  s.platform         = :ios, '13.0'
  s.source           = { :path => '.' }

  s.swift_versions    = ['5.3']

  s.vendored_frameworks = 'Pubstar.xcframework'
  s.static_framework = true

  # s.dependency 'Google-Mobile-Ads-SDK', '~> 11.10.0'
  s.dependency 'GoogleAds-IMA-iOS-SDK', '~> 3.26.1'
  s.dependency 'AppLovinSDK', '~> 13.5.0'
  s.dependency 'PrebidMobile', '~> 3.0.0'
end

