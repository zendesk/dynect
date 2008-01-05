#!/usr/bin/env rake
#
require 'rubygems'
require 'spec/rake/spectask'
require 'rake/rdoctask'
Gem::manage_gems
require 'rake/gempackagetask'
include FileUtils
require File.join(File.dirname(__FILE__), 'lib', 'version')

# Globals
AUTHORS = ["Dave Hoover", "Colin Harris"]
EMAIL = "dave@obtiva.com"
# Project
DESCRIPTION = "Simple wrapper for Dynect SOAP API"
GEM_NAME = 'dynect' 
NAME = GEM_NAME
REV = `svn info`.each {|line| if line =~ /^Revision:/ then k,v = line.split(': '); break v.chomp; else next; end} rescue nil
VERS = Dynect::VERSION::STRING + (REV ? ".#{REV}" : "")

PACKAGE_DIR = "./gem"
HOMEPAGE = "http://rubyforge.org/projects/dynect/"

task :default => :spec

# Run the specs
Spec::Rake::SpecTask.new do |t|
      t.warning = false
      t.spec_files = FileList["spec/*_spec.rb"]
      t.rcov = false
end

# Generate RDocs
Rake::RDocTask.new do |rd|
    # rd.main = "README.rdoc"
    rd.rdoc_dir = "doc"
    rd.rdoc_files.include("lib/**/*.rb") #"README.rdoc",
end

# Create gemspec for gem
spec = Gem::Specification.new do |s|
  s.name = GEM_NAME
  s.platform = Gem::Platform::RUBY
  s.summary = DESCRIPTION
  s.description = DESCRIPTION
  s.homepage = HOMEPAGE
  s.version = VERS
  s.autorequire = GEM_NAME
  s.email = EMAIL
  s.authors = AUTHORS
  s.files = FileList["README","{bin,test,lib,docs,spec}/**/*"].to_a
  s.test_files = Dir.glob("spec/*_spec.rb")
  s.require_path = 'lib'
  s.bindir = 'bin'
  s.executables = [ "dynect-cmd" ]
  s.has_rdoc = true
  s.add_dependency('soap4r')
  s.add_dependency('rspec')
  s.rubyforge_project = 'dynect'
  s.date = %q{`date`}
  s.requirements = []
end

# Create gem
Rake::GemPackageTask.new(spec) do |pkg|
  pkg.need_tar = true
  pkg.package_dir = PACKAGE_DIR
end
