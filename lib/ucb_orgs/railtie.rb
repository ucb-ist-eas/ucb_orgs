class UcbOrgs::Railtie < Rails::Railtie
  rake_tasks do
    load "ucb_orgs/tasks/ucb_orgs.rake"
  end
end
