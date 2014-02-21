Gem::Specification.new do |s|
  s.name      = 'deep_hash_transform'
  s.version   = '1.0.0'
  s.author    = 'Rails Backport'
  s.email     = 'support@basecamp.com'
  s.homepage  = 'https://github.com/basecamp/deep_hash_transform'
  s.summary   = 'Re-key a nested Hash to all-Symbol or -String keys'
  s.license   = 'MIT'

  s.required_ruby_version = '>= 1.8.7'

  s.add_development_dependency 'rake', '~> 10.1'
  s.add_development_dependency 'minitest', '~> 5.1'

  root = File.dirname(__FILE__)
  s.files += Dir["#{root}/lib/**/*"]
  s.test_files = Dir["#{root}/test/**/*"]
end
