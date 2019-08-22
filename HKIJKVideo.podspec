#
# Be sure to run `pod lib lint HKIJKVideo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HKIJKVideo'
  s.version          = '0.1.0'
  s.summary          = 'A short description of HKIJKVideo.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'git@gitlab.ops.xxx.com:lilei1/HKIJKVideo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lefo720' => 'lilei1@xxx.com' }
  s.source           = { :git => 'git@gitlab.ops.xxx.com:lilei1/hkijkvideo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'HKIJKVideo/Classes/**/*'
  #s.ios.resource_bundle = { 'HKIJKVideo' => 'HKIJKVideo/Assets/*.png' }
  s.resource_bundles = {
      'HKIJKVideo' => ['HKIJKVideo/Assets/*.*']
  }
  #s.resource_bundles = {
  #    'HKIJKVideo' => ['HKIJKVideo/Assets/**/*']
  #}
  s.vendored_frameworks =  'HKIJKVideo/libs/IJKMediaFramework.framework'
  s.libraries = 'z', 'bz2'
  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AudioToolbox', 'CoreAudio', 'CoreMedia', 'MediaPlayer', 'QuartzCore', 'OpenGLES', 'VideoToolbox', 'MobileCoreServices', 'CoreGraphics', 'AVFoundation'
  s.dependency 'Masonry'
  s.static_framework  =  true
end