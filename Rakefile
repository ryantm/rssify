require 'rake'
require 'spec/rake/spectask'

task :default=>:examples

desc "Run all examples"
Spec::Rake::SpecTask.new('examples') do |t|
  t.spec_files = FileList['examples/**/*.rb']
end
