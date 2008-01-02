Gem::Specification.new do |s|
        s.has_rdoc = true
        s.name = %q{dynect}
        s.version = "0.0.1" 
        s.rubyforge_project = 'dynect'
        s.date = %q{2008-01-02}
        s.summary = %q{Simple wrapper for Dynect SOAP API.}
        s.description = %q{Simple wrapper for Dynect SOAP API.}
        s.email = %q{dave@obtiva.com}
        s.homepage = %q{http://rubyforge.org/projects/dynect/}
        s.authors = ["Dave Hoover", "Colin Harris"]
        s.require_paths = ['lib']
        s.add_dependency('soap4r')
        s.add_dependency('rspec')
        s.requirements = []
        s.files = ["lib/dynect.rb"]
        s.test_files = Dir.glob("spec/*_spec.rb")
end