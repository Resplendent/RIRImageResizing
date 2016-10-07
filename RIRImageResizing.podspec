#
# Be sure to run `pod lib lint RIRImageResizing.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'RIRImageResizing'
  s.version          = '0.1.0'
  s.summary          = 'A library with tools to resize an image.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
A library with tools to resize an image.
Resizing methods offer:
1) newSize
2) resizeMode
                       DESC

  s.homepage         = 'https://github.com/<GITHUB_USERNAME>/RIRImageResizing'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Benjamin Maer' => 'ben@resplendent.co' }
  s.source           = { :git => 'https://github.com/<GITHUB_USERNAME>/RIRImageResizing.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'RIRImageResizing/Classes/**/*'
end
