Pod::Spec.new do |s|
  s.name             = 'RegeributedTextView'
  s.version          = '0.2.0'
  s.summary          = '`RegeributedTextView` is a subclass of `UITextView` and very easy to use attribute string.'

  s.description      = <<-DESC
RegeributedTextView is a subclass of UITextView that supports attribute string based on regular expression. 
                       DESC

  s.homepage         = 'https://github.com/rinov/RegeributedTextView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'rinov' => 'rinov@rinov.jp' }
  s.source           = { :git => 'https://github.com/rinov/RegeributedTextView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'RegeributedTextView/Classes/**/*'
end
