require "ucb_orgs/syncer"

namespace :ucb_orgs do
  desc "Installs migrations to the current project"
  task :install do
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
  task update: :environment do
    puts "Updating org units..."
    begin
      UcbOrgs::Syncer.sync
      puts "Done."
    rescue Exception => e
      msg = e.respond_to?(:error_details) ? e.error_details : e.to_s
      puts "Unable to complete sync: #{msg}"
    end
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
