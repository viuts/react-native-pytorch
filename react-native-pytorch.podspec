require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name         = package['podName']
  s.version      = package['version']
  s.license      = package['license']
  s.homepage     = package['homepage']
  s.authors      = package['contributors'].flat_map { |author| { author['name'] => author['email'] } }
  s.summary      = package['description']
  s.source       = { :git => package['repository']['url'] }
  s.source_files = 'ios/*.{h,m,mm,swift}', 'ios/*/**.{h,m,mm,swift}'
  s.platform     = :ios, '12.0'
  s.requires_arc = true

  s.dependency "React"
  s.dependency 'LibTorch', '~> 1.3.0'
  s.xcconfig = { 'HEADER_SEARCH_PATHS' => '"$(PODS_ROOT)/LibTorch/install/include/"' }

end

  
