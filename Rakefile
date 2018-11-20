# frozen_string_literal: true

require 'rake/testtask'

task :default do
  puts `rake -T`
end

desc 'generate correct answer'
task :gen do
  sh 'ruby mlb_stats_info.rb'
end

desc 'Run tests once'
Rake::TestTask.new(:spec) do |t|
  t.pattern = 'spec/*_spec.rb'
  t.warning = false
end

desc 'Run acceptance tests'
task :spec_accept do
  puts 'NOTE: run `rake run:test` in another process'
  sh 'ruby spec/acceptance_spec_.rb'
end

desc 'Clean db and rerun server'
task :web do
  sh 'clear'
  sh 'rake db:drop'
  sh 'rake db:migrate'
  sh 'rackup'
end

desc 'run tests'
task :gateway_spec do
  sh 'ruby spec/gateway_mlb_api_spec.rb'
end

desc 'run db tests'
task :spec_db do
  sh 'ruby spec/gateway_database_spec.rb'
end

desc 'run domain tests'
task :spec_domain do
  sh 'ruby spec/domain_speccc.rb'
end

desc 'Keep rerunning tests upon changes'
task :respec do
  sh "rerun -c 'rake spec' --ignore 'coverage/*'"
end

desc 'Keep restarting web app upon changes'
task :rerack do
  sh "rerun -c rackup --ignore 'coverage/*'"
end

namespace :db do
  task :config do
    require 'sequel'
    require_relative 'config/environment.rb' # load config info
    require_relative 'spec/helpers/database_helper.rb'
    # rubocop:disable SingleLineMethods
    def app; MLBAtBat::App; end
    # rubocop:enable  SingleLineMethods
  end

  desc 'Run migrations'
  task :migrate => :config do
    Sequel.extension :migration
    puts "Migrating #{app.environment} database to latest"
    Sequel::Migrator.run(app.DB, 'app/infrastructure/database/migrations')
  end

  desc 'Wipe records from all tables'
  task :wipe => :config do
    DatabaseHelper.setup_database_cleaner
    DatabaseHelper.wipe_database
  end

  desc 'Delete dev or test database file'
  task :drop => :config do
    if app.environment == :production
      puts 'Cannot remove production database!'
      return
    end

    FileUtils.rm(MLBAtBat::App.config.DB_FILENAME)
    puts "Deleted #{MLBAtBat::App.config.DB_FILENAME}"
  end
end

desc 'Run application console (pry)'
task :console do
  sh 'pry -r ./init.rb'
end

namespace :vcr do
  desc 'delete cassette fixtures'
  task :wipe do
    sh 'rm spec/fixtures/cassettes/*.yml' do |ok, _|
      puts(ok ? 'Cassettes deleted' : 'No cassettes found')
    end
  end
end

namespace :quality do
  CODE = 'lib/'

  desc 'run all quality checks'
  task all: %i[rubocop reek flog]

  desc 'rubocop all files'
  task :rubocop do
    sh 'rubocop app/'
  end

  task :reek do
    sh "reek #{CODE}"
  end

  task :flog do
    sh "flog #{CODE}"
  end
end