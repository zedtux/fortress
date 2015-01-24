require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

# Imported Rails rake task
desc 'Print out all defined routes in match order, with names.'
task :routes do
  $LOAD_PATH.unshift('spec/')
  require 'fixtures/application'
  all_routes = Rails.application.routes.routes
  require 'action_dispatch/routing/inspector'
  inspector = ActionDispatch::Routing::RoutesInspector.new(all_routes)
  puts inspector.format(ActionDispatch::Routing::ConsoleFormatter.new)
end

RSpec::Core::RakeTask.new

task default: :spec
task test: :spec
