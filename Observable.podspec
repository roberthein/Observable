Pod::Spec.new do |s|
  s.name = 'Observable'
  s.version = '2.2.1'
  s.swift_versions = [5.0]
  s.ios.deployment_target = '16.0'
  s.osx.deployment_target = '14.0'
  s.summary = 'The easiest way to observe values in Swift'
  s.description = <<-DESC
    Observable is the easiest way to observe values in Swift
  DESC
  s.homepage = 'https://github.com/roberthein/Observable'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Robert-Hein Hooijmans' => 'rh.hooijmans@gmail.com' }
  s.social_media_url = 'https://twitter.com/roberthein'
  s.source = { :git => 'https://github.com/roberthein/Observable.git', :tag => s.version.to_s }
  s.source_files = 'Observable/Classes/**/*.{swift}'
end
