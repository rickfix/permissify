Gem::Specification.new do |s|
  s.name        = "permissify"
  s.version     = "0.1.0"
  s.author      = "Frederick Fix"
  s.email       = "rickfix80004@gmail.com"
  s.homepage    = "http://github.com/rickfix/permissify"
  s.summary     = "Multi-dimensional authorization solution for Rails."
  s.description = "An(other) Rails authorization solution which allows an app to aggregate and arbitrate authorization for permissions from multiple roles and multiple products (permissifed models)."

  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"] - ["Gemfile.lock"]
  s.require_path = "lib"

  s.add_development_dependency 'rspec', '~> 2.6.0' # sure... why not?
  s.add_development_dependency 'rails', '~> 3.2' # ??

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4"
end
