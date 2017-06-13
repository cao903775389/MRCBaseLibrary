#
# Be sure to run `pod lib lint MRCBase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'MRCBaseLibrary'
s.version          = '1.0.0'
s.summary          = 'iOS基础组件.'
s.description      = <<-DESC
    用于组建一个完整的项目所进行的封装，包括组件化探索，基类控制器封装，MVVM+ReactiveSwift框架实践, 网络层封装，通知以及UserDefault命名参数化实践
                    DESC

s.homepage         = 'https://github.com/cao903775389/MRCBaseLibrary'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'cao903775389' => '903775389@qq.com' }
s.source           = { :git => 'https://github.com/cao903775389/MRCBaseLibrary.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.platform     = :ios
s.ios.deployment_target = '8.0'

s.source_files = 'MRCBaseLibrary/Classes/MRCBaseViewController/*', 'MRCBaseLibrary/Classes/MRCBaseViewModel/*', 'MRCBaseLibrary/Classes/MRCExtension/*', 'MRCBaseLibrary/Classes/MRCWrapper/*', 'MRCBaseLibrary/Classes/MRCBaseMediator/*'

s.resource_bundles = {
'MRCBaseLibrary' => ['MRCBaseLibrary/Assets/*.png']
}

# s.public_header_files = 'Pod/Classes/**/*.h'
s.frameworks = 'UIKit', 'WebKit'
s.dependency 'RTRootNavigationController', ' ~> 0.5.26'
s.dependency 'NJKWebViewProgress', '~> 0.2.3'
s.dependency 'WebViewJavascriptBridge', '5.0.7'
s.dependency 'SVProgressHUD', '~> 2.1.2'
s.dependency 'ReactiveCocoa', '~> 5.0.3'
s.dependency 'Nimbus/Models', '~> 1.3.0'
# s.dependency 'HandyJSON', '~> 1.7.1'
s.dependency 'MJRefresh', '~> 3.1.12'
s.dependency 'DZNEmptyDataSet', '~> 1.8.1'
s.dependency 'OLNetwork', '~> 1.2'
s.dependency 'SwiftyJSON', '~> 3.1.4'
s.dependency 'UITableView+FDTemplateLayoutCell', '~> 1.6'
end
