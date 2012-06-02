Gem::Specification.new do |s|
  s.name        = "permissify"
  s.version     = "0.0.8"
  s.author      = "Frederick Fix"
  s.email       = "rickfix80004@gmail.com"
  s.homepage    = "http://github.com/rickfix/permissify"
  s.summary     = "Not so simple authorization solution for Rails."
  s.description = "Not so simple authorization solution for Rails."

  s.files        = Dir["{lib,spec}/**/*", "[A-Z]*", "init.rb"] - ["Gemfile.lock"]
  s.require_path = "lib"

  s.add_development_dependency 'rspec', '~> 2.6.0' # sure... why not?
  s.add_development_dependency 'rails', '~> 3.0.9' # ??
  # s.add_development_dependency 'rr', '~> 0.10.11' # ?? # 1.0.0 has respond_to? issues: http://github.com/btakita/rr/issues/issue/43
  # s.add_development_dependency 'supermodel', '~> 0.1.4' # ??

  s.rubyforge_project = s.name
  s.required_rubygems_version = ">= 1.3.4" # ??
end
