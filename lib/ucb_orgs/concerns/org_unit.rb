module UcbOrgs
  module Concerns
    module OrgUnit
      extend ActiveSupport::Concern

      module ClassMethods

        def load_from_csv(csv_filename)
          CSV.foreach(csv_filename, headers: true) do |row|
            org_unit = UcbOrgs::OrgUnit.find_or_create_by(code: row['CODE'])
            org_unit.update_attributes(
              name:  row['NAME'],
              level:  row['LEVEL'].to_i,
              level_2:  row['LEVEL_2'],
              level_3:  row['LEVEL_3'],
              level_4:  row['LEVEL_4'],
              level_5:  row['LEVEL_5'],
              level_6:  row['LEVEL_6']
            )
          end
        end

        # Returns an Array of org codes consisting of the given org and all child orgs. "org" can also
        # be a list of orgs. The result will have all duplicate org codes filtered out.
        def org_with_children(org)
          orgs = Array(org)
          return [] if orgs.empty?
          orgs_str = orgs.reduce("(") { |res,org| res + "'#{org}'," }.chop + ")"
          # TODO we can clean this up with "or" queries in Rails 5
          UcbOrgs::OrgUnit
            .where(
              "code IN #{orgs_str}" +
              "OR level_2 IN #{orgs_str}" +
              "OR level_3 IN #{orgs_str}" +
              "OR level_4 IN #{orgs_str}" +
              "OR level_5 IN #{orgs_str}" +
              "OR level_6 IN #{orgs_str}"
            )
            .uniq
            .pluck(:code)
        end
      end
    end
  end
end
