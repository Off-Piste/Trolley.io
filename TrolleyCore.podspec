#
#  Be sure to run `pod spec lint TrolleyCore.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TrolleyCore"
  s.version      = "0.0.1"
  s.summary      = "TrolleyCore is a mobile and web ecommerce system"
  s.description  = <<-DESC
  A very very very very very very short description of TrolleyCore.
  TrolleyCore is a mobile and web ecommerce system.
                   DESC

  s.homepage     = "https://github.com/harrytwright/trolley_core"

  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "harrytwright" => "haroldtomwright@gmail.com" }

  s.platform     = :ios, 10.0
  s.source       = { :git => "https://github.com/harrytwright/trolley_core.git", :tag => "#{s.version}" }

  # s.preserve_path = 'TrolleyCore/TrolleyCore.modulemap'
  s.module_map = 'TrolleyCore/TrolleyCore.modulemap'

  s.source_files  = 'TrolleyCore/**/**/*.{swift,h,m}'
  s.public_header_files = 'TrolleyCore/Headers/Public/*.h', 'TrolleyCore/TrolleyCore.h'
  s.private_header_files = 'TrolleyCore/Headers/Private/*.h'
  s.dependency 'PromiseKit'

end
