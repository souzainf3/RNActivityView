Pod::Spec.new do |s|
  s.name         = "RNActivityView"
  s.version      = "0.0.8"
  s.summary      = "Displays a translucent ActivityView with an indicator and/or labels. Can UIView category."

  s.description  = <<-DESC
                   Based on MBProgressHUD -  is an iOS drop-in class that displays a translucent ActivityView with an indicator and/or labels while work is being done in a background thread. Can UIView category.
                   DESC

  s.homepage     = "https://github.com/souzainf3/RNActivityView"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Romilson Nunes" => "souzainf3@yahoo.com.br" }
  s.authors            = { "Romilson Nunes" => "souzainf3@yahoo.com.br" }
  s.social_media_url   = "http://twitter.com/souzainf3"
  s.source       = { :git => "https://github.com/souzainf3/RNActivityView.git", :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'

  s.source_files  = "RNActivityView/*"
  s.frameworks = "Foundation", "UIKit", "CoreGraphics"
  s.requires_arc = true
end
