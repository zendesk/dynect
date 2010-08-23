# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dynect}
  s.version = "0.0.3.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Dave Hoover", "Colin Harris"]
  s.autorequire = %q{dynect}
  s.date = %q{2010-05-06}
  s.default_executable = %q{dynect-cmd}
  s.description = %q{Simple wrapper for Dynect SOAP API}
  s.email = %q{dave@obtiva.com}
  s.executables = ["dynect-cmd"]
  s.files = ["README", "bin/dynect-cmd", "lib/version.rb", "lib/dynect.rb", "spec/integration", "spec/integration/dynec_a_record_integration_spec.rb", "spec/integration/dynec_soa_record_integration_spec.rb", "spec/integration/dynec_cname_record_integration_spec.rb", "spec/integration/credentials.yml.example", "spec/dynec_cname_record_spec.rb", "spec/spec_helper.rb", "spec/dynec_a_record_spec.rb", "spec/dynect_zone_spec.rb", "spec/dynec_soa_record_spec.rb"]
  s.homepage = %q{http://rubyforge.org/projects/dynect/}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{dynect}
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Simple wrapper for Dynect SOAP API}
  s.test_files = ["spec/dynec_cname_record_spec.rb", "spec/dynec_a_record_spec.rb", "spec/dynect_zone_spec.rb", "spec/dynec_soa_record_spec.rb"]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<soap4r>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<soap4r>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<soap4r>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end
