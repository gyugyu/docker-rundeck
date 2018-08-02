require "serverspec"
require "docker"

set :backend, :docker

container = Docker::Container.
              all(all: true).
              find {|c| c.info["Image"].include?("_#{ENV["TARGET_HOST"]}") }

set :docker_container, container.id
