#
# Be sure to run `pod lib lint BlockDataSource.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BlockDataSource'
  s.version          = '0.3.0'
  s.summary          = 'A block configurable datasource for static table views'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
		A block configurable datasource for table views. Useful for creating menus and displaying staic data.
                       DESC

  s.homepage         = 'https://github.com/adamcumiskey/BlockDataSource'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Adam Cumiskey' => 'adam.cumiskey@gmail.com' }
  s.source           = { :git => 'https://github.com/adamcumiskey/BlockDataSource.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'BlockDataSource/Classes/**/*'
  
  # s.resource_bundles = {
  #   'BlockDataSource' => ['BlockDataSource/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
