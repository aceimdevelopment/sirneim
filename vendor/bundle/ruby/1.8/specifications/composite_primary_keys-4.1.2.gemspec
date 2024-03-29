# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "composite_primary_keys"
  s.version = "4.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dr Nic Williams", "Charlie Savage"]
  s.date = "2012-01-12"
  s.description = "Composite key support for ActiveRecord 3"
  s.email = ["drnicwilliams@gmail.com"]
  s.homepage = "http://github.com/cfis/composite_primary_keys"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = "compositekeys"
  s.rubygems_version = "1.8.24"
  s.summary = "Composite key support for ActiveRecord"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>, ["~> 3.1"])
    else
      s.add_dependency(%q<activerecord>, ["~> 3.1"])
    end
  else
    s.add_dependency(%q<activerecord>, ["~> 3.1"])
  end
end
