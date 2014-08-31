Gem::Specification.new do |s|
  s.name        = 'nondestructive_migrations'
  s.version     = '0.6.0'
  s.date        = '2014-08-30'
  s.summary     = "Nondestructive (data-only) migrations for your Rails app"
  s.description = "Separate schema-only migrations from nondestrucitve (data) migrations in your Rails app"
  s.authors     = ["Jason Fleetwood-Boldt"]
  s.email       = 'jason@datatravels.com'
  s.files       = ["lib/nondestructive_migrations.rb"]
  s.homepage    =
    'https://github.com/jasonfb/nondestructive_migrations'
  s.license       = 'MIT'
  
  s.add_runtime_dependency 'activerecord', '~> 3.1', '> 3.1'
  s.add_development_dependency 'rails/generators/active_record', '~> 3.1', '> 3.1'
end