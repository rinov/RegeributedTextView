Pod::Spec.new do |s|
  s.name             = 'RegeributedTextView'
  s.version          = '0.1.0'
  s.summary          = 'Regular expression based attribute text written in Swift3.'

  s.description      = <<-DESC
`RegeributedTextView` is a subclass of `UITextView` and very easy to use attributedText.It provides a fully customizable function using `TextAttribute`
                       DESC

  s.homepage         = 'https://github.com/rinov/RegeributedTextView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rinov' => 'rinov@rinov.jp' }
  s.source           = { :git => 'https://github.com/rinov/RegeributedTextView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'RegeributedTextView/Classes/**/*'
  
  # s.frameworks = 'UIKit', 'MapKit'
end
