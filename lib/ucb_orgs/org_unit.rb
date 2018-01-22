require "csv"

module UcbOrgs

  class OrgUnit < ActiveRecord::Base
    include UcbOrgs::Concerns::OrgUnit

    # Don't add anything else here - any other functionality should be added to
    # UcbOrgs::Concerns::OrgUnit. This will make it easier for host apps to
    # customize the class as needed. See:
    # http://edgeguides.rubyonrails.org/engines.html#implementing-decorator-pattern-using-activesupport-concern
  end

end
