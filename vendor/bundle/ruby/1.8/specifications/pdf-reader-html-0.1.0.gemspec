# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "pdf-reader-html"
  s.version = "0.1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Marcus Ortiz"]
  s.date = "2012-04-19"
  s.description = "convert .pdf files into html"
  s.email = "mportiz08@gmail.com"
  s.homepage = "https://github.com/mportiz08/pdf-reader-html"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "convert .pdf files into html"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<pdf-reader>, ["~> 1.1.0"])
      s.add_runtime_dependency(%q<html_writer>, ["~> 0.2.0"])
    else
      s.add_dependency(%q<pdf-reader>, ["~> 1.1.0"])
      s.add_dependency(%q<html_writer>, ["~> 0.2.0"])
    end
  else
    s.add_dependency(%q<pdf-reader>, ["~> 1.1.0"])
    s.add_dependency(%q<html_writer>, ["~> 0.2.0"])
  end
end
