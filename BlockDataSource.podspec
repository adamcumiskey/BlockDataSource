Pod::Spec.new do |s|
  s.name             = 'BlockDataSource'
  s.version          = '0.4.0'
  s.summary          = 'A block configurable datasource for static table views'

  s.description      = <<-DESC
		A block configurable datasource for table views. Useful for creating menus and displaying staic data.
                       DESC

  s.homepage         = 'https://github.com/adamcumiskey/BlockDataSource'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Adam Cumiskey' => 'adam.cumiskey@gmail.com' }
  s.source           = { :git => 'https://github.com/adamcumiskey/BlockDataSource.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.swift_version = '3.2'

  s.source_files = 'BlockDataSource/Classes/**/*'
end
