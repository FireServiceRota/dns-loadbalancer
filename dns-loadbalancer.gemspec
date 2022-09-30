Gem::Specification.new do |s|
  s.name        = 'dns-loadbalancer'
  s.version     = '1.1.0'
  s.summary     = 'Gem for resolving a DNS host to the closest IP address'
  s.authors     = ['Ruben Stranders']
  s.email       = 'ruben@fireservicerota.com'
  s.files       = ['lib/dns-loadbalancer.rb']
  s.homepage    = 'https://github.com/FireServiceRota/dns-loadbalancer'
  s.license     = 'MIT'
  s.add_runtime_dependency 'ipaddress', ['~>0.8']
  s.add_runtime_dependency 'net-ping', ['~>2.0']
  s.add_runtime_dependency 'resolv', ['~>0.2']
end
