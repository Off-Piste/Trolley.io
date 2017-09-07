#
#  Be sure to run `pod spec lint Trolley.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "Trolley"
  s.version      = "0.0.3"
  s.summary      = "Trolley is a mobile and web ecommerce system"
  s.description  = <<-DESC
  A very very very very very very short description of Trolley.
  Trolley is a mobile and web ecommerce system
                   DESC

  s.homepage     = "https://github.com/harrytwright/trolley_new"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "harrytwright" => "haroldtomwright@gmail.com" }
  s.source       = { :git => "https://github.com/harrytwright/trolley_root.git", :tag => "#{s.version}" }

  s.default_subspec  = 'Root'
  s.module_map = 'Trolley/module.modulemap'
  s.platform     = :ios, '10.0'

  s.subspec 'Root' do |ss|
    ss.source_files = 'Trolley/Trolley.h'
    ss.public_header_files = 'Trolley/Trolley.h'
    # ss.dependency 'TrolleyCore'
  end

  # s.subspec 'Core' do |ss|
  #   ss.dependency 'Trolley/Root'
  #   ss.dependency 'TrolleyCore'
  #
  # end

end
