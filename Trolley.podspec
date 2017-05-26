#
# Be sure to run `pod lib lint Trolley.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Trolley'
  s.version          = '0.1.0'
  s.summary          = 'A short description of Trolley For Life fite me'

  s.description      = <<-DESC
A short description of Trolley for me to do later
                       DESC

  s.homepage         = 'https://github.com/Off-Piste/Trolley.io'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'harrytwright' => 'haroldtomwright@gmail.com' }
  s.source           = { :git => 'https://github.com/Off-Piste/Trolley.io.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Trolley/**/**/*'
  s.frameworks = 'Foundation', 'UIKit', 'PassKit'
  s.default_subspecs = 'Default'

  s.subspec 'Core' do |core|
      core.source_files = 'Trolley/Core/**/**/*.swift'
  end

  s.subspec 'Networking' do |n|
      n.source_files = 'Trolley/Networking/**/**/*.swift'
      n.dependency 'Trolley/Core'
      # n.dependency 'ReachabilitySwift', '~> 3' // To work Reachabilty with Promise kit, have to insert the reachabilty manually
      n.dependency 'PromiseKit'
  end

  s.subspec 'Database' do |d|
      d.source_files = 'Trolley/Database/**/**/*.swift'
      d.dependency 'Trolley/Networking'
      d.dependency 'SwiftyJSON'
      d.dependency 'PromiseKit/Alamofire'
  end

  s.subspec 'Default' do |default|
      default.source_files = 'Trolley/API/**/**/*.swift'
      default.dependency 'Trolley/Database'
      default.dependency 'PromiseKit/CoreLocation'
  end

end
