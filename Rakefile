require "rake"
require "rspec/core/rake_task"

task :spec    => "spec:all"
task :default => :spec

namespace :spec do
  targets = []
  Dir.glob("./spec/*").each do |dir|
    next unless File.directory?(dir)

    target = File.basename(dir)
    target = "_#{target}" if target == "default"
    targets << target
  end

  task :all     => targets
  task :default => :all

  targets.each do |target|
    original_target = (target == "_default") ? target[1..-1] : target
    desc "Run serverspec tests to #{original_target}"
    RSpec::Core::RakeTask.new(target.to_sym) do |t|
      ENV["TARGET_HOST"] = original_target
      t.pattern = "spec/#{original_target}/*_spec.rb"
    end
  end
end

namespace :node do
  task :test do
    sh "npm run cypress:run"
  end

  task :npm_ci do
    sh "npm ci"
  end

  task node: :nvm do
    sh({"NVM_DIR" => "$HOME/.nvm"}, ". $NVM_DIR/nvm.sh && nvm install v10.7.0 && nvm alias default v10.7.0")
  end

  task :nvm do
    sh "curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash"
  end
end
