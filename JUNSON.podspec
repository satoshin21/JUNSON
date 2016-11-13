#
# Be sure to run `pod lib lint JUNSON.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JUNSON'
  s.version          = ‘0.2.1’
  s.summary          = 'type-safe decode and encode Library for Swift3.0.'
  s.homepage         = 'https://github.com/SatoshiN21/JUNSON'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'SatoshiN21' => 'satoshi.nagasaka21@gmail.com' }
  s.source           = { :git => 'https://github.com/SatoshiN21/JUNSON.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/SatoshiN21’
  s.ios.deployment_target = '8.0'
  s.source_files = 'JUNSON/Classes/**/*.swift'
end
