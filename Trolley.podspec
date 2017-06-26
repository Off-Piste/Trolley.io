#
# Be sure to run `pod lib lint Trolley.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

# TODO: Change Names

Pod::Spec.new do |s|
  s.name             = 'Trolley'
  s.version          = '0.1.0'
  s.summary          = 'Trolley is everything I could wish for'

  s.description      = <<-DESC
A very very very very very very very short description of Trolley for me to do later
                       DESC

  s.homepage         = 'https://github.com/Off-Piste/Trolley.io'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'harrytwright' => 'haroldtomwright@gmail.com' }
  s.source           = { :git => 'https://github.com/Off-Piste/Trolley.io.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.frameworks = 'Foundation', 'UIKit', 'PassKit'
  s.default_subspecs = 'Core'

  s.subspec 'Core' do |c|
      networking = ['Trolley/Core/Networking/**/**/*.swift']
      core = ['Trolley/Core/Core/**/**/*.swift']
      core += networking
      c.source_files = core

      c.dependency 'PromiseKit/CoreLocation'
      c.dependency 'PromiseKit'
      c.dependency 'SwiftyJSON'
      c.dependency 'PromiseKit/Alamofire'
  end

  s.subspec 'Database' do |d|
      networking = ['Trolley/Database/TRLDatabaseNetworking/**/**/*.swift']
      core = ['Trolley/Database/TRLDatabaseCore/**/**/*.swift']
      core += networking

      d.source_files = core
      d.dependency 'Trolley/Core'
  end

end
