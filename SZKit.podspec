
Pod::Spec.new do |s|

    s.name          = "SZKit"
    s.version       = "1.1.7"
    s.summary       = "a set for convenient develop."

    s.homepage      = "https://github.com/StenpZ/SZKit"
    s.license       = "MIT"

    s.author        = { "StenpZ" => "zhouc520@foxmail.com" }
    s.source        = { :git => "https://github.com/StenpZ/SZKit.git", :tag => "#{s.version}" }
    s.public_header_files = 'SZKit/**/*.{h}'
    s.source_files  = "SZKit/**/*.{h,m}"
    s.frameworks    = 'UIKit'
    s.platform      = :ios,'8.0'
    s.requires_arc = true

    s.dependency 'SDWebImage', '~> 4.1.2'
    s.dependency 'Masonry', '~> 1.1.0'


end
