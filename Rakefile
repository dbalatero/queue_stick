require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "queue-tip"
    gem.summary = %Q{TODO}
    gem.email = "dbalatero@gmail.com"
    gem.homepage = "http://github.com/dbalatero/queue-tip"
    gem.authors = ["David Balatero"]

    gem.add_dependency('sinatra', '>= 0.9.1')

    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "queue-tip #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  require 'flog'

  desc "Analyze code complexity"
  task :flog do
    flog = Flog.new
    flog.flog_files ['lib']
    threshold = 25

    bad_methods = flog.totals.select do |name, score|
      score > threshold
    end

    bad_methods.sort { |a, b| a[1] <=> b[1] }.each do |name, score|
      puts "%8.1f: %s" % [score, name]
    end

    raise "#{bad_methods.size} methods have a flog complexity > #{threshold}" unless bad_methods.empty?
  end
rescue LoadError
end

begin
  require 'flay'
  desc "Analyze for code duplication"
  task :flay do
    threshold = 25
    flay = Flay.new(:fuzzy => false,
                    :verbose => false,
                    :mass => threshold)
    flay.process(*Flay.expand_dirs_to_files(['lib']))
    flay.report

    raise "#{flay.masses.size} chunks of code have a duplicate mass > #{threshold}" unless flay.masses.empty?
  end
rescue LoadError
end
