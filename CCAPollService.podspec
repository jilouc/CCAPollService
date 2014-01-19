Pod::Spec.new do |s|
  s.name = 'CCAPollService'
  s.version = '1.0'
  s.license = 'MIT'
  s.summary = 'Wrapper around NSTimer for repeated operations, with both block and delegate API.'
  s.homepage = 'https://github.com/jilouc/CCAPollService'
  s.authors = { 'Jean-Luc Dagon' => 'jldagon@cocoapps.fr'}
  s.source = { :git => 'https://github.com/jilouc/CCAPollService.git', :tag => '1.0' }
  s.source_files = 'CCAPollService/*.{h,m}'

  s.requires_arc = true
  s.ios.deployment_target = '6.0'
  s.ios.frameworks = 'QuartzCore'

end
