# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "bem_html"
  s.version     = "1.1.0"
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Andrew Pilsch"]
  s.email       = ["apilsch@tamu.edu"]
  s.homepage    = "https://github.com/oncomouse/bem_html"
  s.summary     = %q{Build BEM class tags on HTML elements from HTML attributes (bem-block, bem-element, and bem-modifiers).}
  # s.description = %q{A longer description of your extension}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  # The version of middleman-core your extension depends on
  s.add_runtime_dependency("nokogiri", ["~> 1.6"])
  
  s.license = "ISC"
  
  # Additional dependencies
  # s.add_runtime_dependency("gem-name", "gem-version")
end
