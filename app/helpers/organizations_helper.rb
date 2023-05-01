# frozen_string_literal: true

module OrganizationsHelper
    
    def sort_link(column:, label:)
        if column == params[:column]
            link_to(label, list_organizations_path(column: column, direction: next_direction))
        else
            link_to(label, list_organizations_path(column: column, direction: 'asc'))
        end
    end
        
    def next_direction
        params[:direction] == 'asc' ? 'desc' : 'asc'
    end

    def sort_indicator
        tag.span(class: "sort sort-#{params[:direction]}")
    end

    def check_param(id)
        if cookies.has_key?(:organizations_ids) and cookies[:organizations_ids] != nil
            if cookies[:organizations_ids].split('&').index(id.to_s)
                return true
            else
                return false
            end
        else
            return false
        end
    end

    def check_org_session_exists(value, string)
        if value != nil
            return value[string]
        else
            return ""
        end
    end

    # def add_table_entry(org_name:, contact_name:, contact_email:, officer_position:)
    #     org_name = params[:org_name] 
    #     contact_name = params[:contact_name]
    #     contact_email = params[:contact_email]
    #     officer_position = params[:officer_position]

    #     org_count = 0
    #     contact_count = 0
    #     con_org_count = 0
    #     org = {}
    #     contact = {}
    #     con_org = {}
    #     while Organization.where(organization_id: org_count).exists? do
    #         org_count = org_count + 1
    #     end
    #     while Contact.where(contact_id: contact_count).exists? do
    #         contact_count = contact_count + 1
    #     end
    #     while ContactOrganization.where(contact_organization_id: con_org_count).exists? do
    #         con_org_count = con_org_count + 1
    #     end

    #     puts "ORG ID: #{org_count}"

    #     query = "INSERT INTO organizations (organization_id, name, description) VALUES (#{org_count}, #{org_name}, 'None');"
    #     orgs = ActiveRecord::Base.connection.execute(query)

    #     query = "INSERT INTO contacts (contact_id, year, name, email, officer_position, description) VALUES (#{contact_count}, #{Date.today}, #{contact_name}, #{contact_email}, #{officer_position},  'None');"
    #     contacts = ActiveRecord::Base.connection.execute(query)

    #     query = "INSERT INTO contact_organizations (contact_organization_id, contact_id, organization_id) VALUES (#{con_org_count}, #{contact_count}, #{org_count});"
    #     contacts = ActiveRecord::Base.connection.execute(query)
    #     # Autofill in organization: organization_id, organization_description
    #     # Autofill in contact_organization: contact_organization_id, contact_id, organization_id
    #     # Autofill in contact: contact_id, year, description
    # end
end
