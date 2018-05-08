module UcbOrgs
  class SyncError < StandardError
    attr_reader :item
    attr_reader :source_error

    def initialize(item, source_error)
      @item = item
      @source_error = source_error
    end

    def error_details
      "#{source_error} : #{source_error.backtrace.first}"
    end
  end

  # Syncs the org units to the LDAP tree
  #
  # Since ldap is definitive and we don't keep org history,
  # delete any department row that wasn't found in ldap.
  #
  # Most of this code was lifted wholesale from APBears
  class Syncer
    attr_accessor :ldap_org_entries

    class << self
      def sync
        UcbOrgs::Syncer.new.sync
      end
    end

    def sync
      ::UCB::LDAP::Org.root_node  # force load of whole tree
      self.ldap_org_entries = ::UCB::LDAP::Org.flattened_tree

      sync_orgs
      delete_not_found_in_ldap
    end

    private

    def sync_orgs
      ldap_org_entries.each do |ldap_org_entry|
        begin
          sync_org(ldap_org_entry)
        rescue Exception => e
          raise UcbOrgs::SyncError.new(ldap_org_entry.try(:code), e)
        end
      end
    end

    def delete_not_found_in_ldap
      codes_found_in_ldap = ldap_org_entries.map(&:code)
      codes_found_in_db = UcbOrgs::OrgUnit.all.map(&:code)
      codes_to_delete = codes_found_in_db - codes_found_in_ldap

      UcbOrgs::OrgUnit
        .where(code: codes_to_delete)
        .delete_all
    end

    def sync_org(ldap_org_entry)
      code = nb_to_string(ldap_org_entry.code)
      UcbOrgs::OrgUnit.find_or_initialize_by(code: code).tap do |org|
        org.update_attributes!(
          code: code,
          name: nb_to_string(ldap_org_entry.name),
          level: ldap_org_entry.level,
          level_2: nb_to_string(ldap_org_entry.level_2_code),
          level_3: nb_to_string(ldap_org_entry.level_3_code),
          level_4: nb_to_string(ldap_org_entry.level_4_code),
          level_5: nb_to_string(ldap_org_entry.level_5_code),
          level_6: nb_to_string(ldap_org_entry.level_6_code)
        )
      end
    end

    # Net-Ldap returns Net::BER::BerIdentifiedString.
    # Explicityly convert to String.
    def nb_to_string(nb)
      nb.nil? ? nil : nb.to_s
    end

  end
end
