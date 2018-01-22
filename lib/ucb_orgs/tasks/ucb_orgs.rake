require "open-uri"

ORG_UNIT_URL = "https://s3-us-west-2.amazonaws.com/ucb-orgs/org_units/latest.csv"

namespace :ucb_orgs do
  desc "Sets up the database and imports seed data"
  task :install do
    Rake::Task["ucb_orgs:install_migrations"].invoke
  end

  desc "Adds migrations to the current project"
  task :install_migrations do
    puts "Checking for new migrations..."
    migrations_to_add = new_migrations()
    if migrations_to_add.empty?
      puts "No new migrations"
    else
      migrations_to_add.each do |migration|
        FileUtils.cp("#{migration_source_dir}/#{migration}", migration_target_dir)
      end
      puts "\nMigrations installed - ready to run \"rake db:migrate\""
    end
  end

  desc "Downloads org unit source file, and loads it into the database"
  task :update do
    puts "Downloading org units..."
    org_unit_csv = open(ORG_UNIT_URL)
    begin
      # this command fails with JRuby on Ubuntu
      FileUtils.mv(org_unit_csv.path, "./latest.csv")
    rescue Exception => e
      # if it chokes, we fall back to a system command, and hope we're not on Windows...
      `mv #{org_unit_csv.path} ./latest.csv`
    end

    puts "Loading org units..."
    #require 'yaml'
    #config = YAML.load_file("#{Rails.root}/config/database.yml")[Rails.env]
    # TODO: this will be different in > Rails 3
    #ActiveRecord::Base.establish_connection(config)
    UcbOrgs::OrgUnit.load_from_csv("./latest.csv")

    puts "Cleaning up..."
    FileUtils.remove_file("./latest.csv")

    puts "Done."
  end

  def migration_source_dir
    "#{File.dirname(__FILE__)}/../migrations/"
  end

  def migration_target_dir
    "#{Rails.root}/db/migrate"
  end

  def new_migrations
    already_installed = Dir.entries(migration_target_dir)
    Dir.entries(migration_source_dir).reject do |m|
      already_installed.include?(m)
    end
  end
end
