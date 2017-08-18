Pod::Spec.new do |s|
  s.name         = 'Observable'
  s.version      = '1.0.0'
  s.ios.deployment_target = '8.0'
  s.tvos.deployment_target = '8.0'
  s.summary      = 'Create observable, add observer and observe...'
  s.description  = <<-DESC
    Observable is a reactive library before it becomes complicated (or interesting)
  DESC
  s.homepage           = 'https://github.com/roberthein/Observable'
  s.license            = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { 'Robert-Hein Hooijmans' => 'rh.hooijmans@gmail.com' }
  s.social_media_url   = 'https://twitter.com/roberthein'
  s.source             = { :git => 'https://github.com/roberthein/Observable.git', :tag => s.version.to_s }
  s.source_files       = 'Observable/Classes/**/*.{swift}'
end