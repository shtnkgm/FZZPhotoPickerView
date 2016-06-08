Pod::Spec.new do |s|

s.name         = "FZZPhotoPickerView"
s.version      = "0.0.4"
s.summary      = "PhotosKitを使ってカメラロールの静止画Assetを取得するビュー"
s.homepage     = "http://shtnkgm.github.io/"
s.license      = { :type => "MIT", :file => "LICENSE.txt" }
s.author       = 'Shota Nakagami'
s.platform     = :ios, "8.0"
s.requires_arc = true
s.source       = { :git => "https://shtnkgm@bitbucket.org/shtnkgm/fzzphotopickerview.git", :tag => s.version }
s.source_files = "FZZPhotoPickerKit/FZZ*.{h,m}"
s.framework  = 'Photos', 'UIKit'
end