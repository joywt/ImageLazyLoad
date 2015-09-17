Pod::Spec.new do |s|
  s.name         = "ImageLazyLoad"
  s.platform     = :ios
  s.version      = "1.0.2"
  s.summary      = "List of images in the process of sliding reduce slow down while loading the overhead of network overhead and images"
  s.homepage     = "https://github.com/joywt/ImageLazyLoad"
  s.license      = "MIT"
  s.author      = { "Tie Wang" => "tiewang3399@gmail.com" }
  s.source       = { :git => "https://github.com/joywt/ImageLazyLoad.git", :tag => "#{s.version}" }
  s.framework    = "Foundation"
  s.source_files = "*.{h,m}"
  s.requires_arc = true
end