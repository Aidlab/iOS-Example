Pod::Spec.new do |s|
  s.name             = 'iOS-Example'
  s.version          = '0.1.0'
  s.summary          = 'Aidlab Code Examples for iOS'

  s.description      = <<-DESC
    Aidlab Code Examples for iOS
                       DESC

  s.homepage         = 'https://github.com/Aidlab/iOS-Example'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Aidlab' => 'contact@aidlab.com' }
  s.source           = { :git => 'https://github.com/Aidlab/iOS-Example.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/@getAidlab'

  s.ios.deployment_target = '9.0'

  s.source_files = 'iOS-Example/Classes/**/*'
  
  # s.resource_bundles = {
  #   'iOS-Example' => ['iOS-Example/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
