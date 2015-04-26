#
# Be sure to run `pod lib lint TFFormDescriptor.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "TFFormDescriptor"
  s.version          = "0.1.0"
  s.summary          = "A short description of TFFormDescriptor."
  s.description      = <<-DESC
                       An optional longer description of TFFormDescriptor

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/<GITHUB_USERNAME>/TFFormDescriptor"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ales Kocur" => "aleskocur@icloud.com" }
  s.source           = { :git => "https://github.com/<GITHUB_USERNAME>/TFFormDescriptor.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*.{h,m}'
s.resources = 'Pod/Classes/**/*.{xib}'
#s.resource_bundles = {
#    'TFFormDescriptor' => ['Pod/Assets/*.png', 'Pod/Classes/**/*.xib']
#  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
s.dependency 'TFTableDescriptor', '~> 1.1.0'
#s.dependency 'TFTableDescriptor'

end