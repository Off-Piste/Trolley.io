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

  s.homepage         = 'https://github.com/Off-Piste/Trolley.io-cocoa'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'harrytwright' => 'haroldtomwright@gmail.com' }
  s.source           = {
      :git => 'https://github.com/Off-Piste/Trolley.io-cocoa',
      :tag => 'v0.1.0-alpha'
  }

  s.ios.deployment_target = '8.0'
  s.frameworks = 'Foundation', 'UIKit', 'PassKit'
  s.default_subspecs = 'Core'

  s.subspec 'Core' do |c|
      networking = ['Trolley/Core/Networking/**/**/*.swift']
      core = ['Trolley/Core/Core/**/**/*.swift']
      required = ['Trolley/Core/Root/**/**/*.swift']
      objc = ['Trolley/Core/Core-Objc/**/**/*.swift']
      core += networking
      core += required
      core += objc
      c.source_files = core

      c.dependency 'PromiseKit/CoreLocation'
      c.dependency 'PromiseKit'
      c.dependency 'SwiftyJSON'
      c.dependency 'PromiseKit/Alamofire'
  end

  s.subspec 'Database' do |d|
      networking = ['Trolley/Database/TRLDatabaseNetworking/**/**/*.swift']
      core = ['Trolley/Database/TRLDatabaseCore/**/**/*.swift']
      objc = ['Trolley/Database/TRLDatabase-Objc/**/**/*.swift']
      core += objc
      core += networking

      d.source_files = core
      d.dependency 'Trolley/Core'
  end

  s.subspec 'Notification' do |n|
      n.source_files = 'Trolley/Notification/**/**/*.swift'
      n.dependency 'Trolley/Core'
  end

  s.subspec 'Delivery' do |d|
      d.source_files = 'Trolley/Delivery/**/**/*.swift'
      d.dependency 'Trolley/Core'
  end

  s.subspec 'UI' do |d|
      d.source_files = 'Trolley/Delivery/**/**/*.swift'
      d.dependency 'Trolley/Database'
      d.dependency 'Trolley/Delivery'
  end

end
