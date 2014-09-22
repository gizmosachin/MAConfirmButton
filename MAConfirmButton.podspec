Pod::Spec.new do |s|
  s.name     = 'MAConfirmButton'
  s.version  = '2.0'
  s.summary  = 'UIButton subclass that mirrors behavior of buy buttons in iOS stores.'
  s.license  = 'MIT'
  s.authors  = { "Sachin Patel" => "me@gizmosachin.com", "Mike Ahrmarani" => "" }
  s.homepage = 'https://github.com/gizmosachin/MAConfirmButton'
  s.source   = { :git => 'git@github.com:gizmosachin/MAConfirmButton.git', :tag => 'v2.0' }
  s.frameworks = 'Foundation', 'UIKit', 'QuartzCore', 'CoreGraphics'
  s.platform = :ios, '7.0'
  s.source_files = 'Source'
  s.requires_arc = true
end
