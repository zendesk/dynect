require 'spec/rake/spectask'
require 'rake/rdoctask'

task :default => :spec

Spec::Rake::SpecTask.new do |t|
      t.warning = false
      t.spec_files = FileList["spec/*_spec.rb"]
      t.rcov = false
end

Rake::RDocTask.new do |rd|
    # rd.main = "README.rdoc"
    rd.rdoc_dir = "doc"
    rd.rdoc_files.include("lib/**/*.rb") #"README.rdoc",
end