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

  s.description      = <<-DESC
		A block configurable datasource for table views. Useful for creating menus and displaying staic data.
                       DESC

  s.homepage         = 'https://github.com/adamcumiskey/BlockDataSource'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Adam Cumiskey' => 'adam.cumiskey@gmail.com' }
  s.source           = { :git => 'https://github.com/adamcumiskey/BlockDataSource.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'BlockDataSource/Classes/DataSource.swift'
  
  s.subspec 'ViewControllers' do |ss|
      ss.source_files = 'BlockDataSource/Classes/ViewControllers.swift'
  end
  
end
