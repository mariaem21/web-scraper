# frozen_string_literal: true

class Organization < ApplicationRecord
    has_many :contact_organizations
    has_many :contacts, through: :contact_organizations

    validates :organization_id, presence: true, uniqueness: true
    validates :name, presence: true, uniqueness: true
    validates :description, presence: true

    def self.only_ids
        pluck(:organization_id)
    end

    # general query
    def self.organizations_query

        orgs_query = 
        "SELECT 
            contact_organizations.contact_organization_id,
            organizations.name AS org_name,
            organizations.organization_id,
            contacts.name AS contact_name,
            contacts.contact_id,
            contacts.email,
            contacts.officer_position,
            contacts.year,
            app_counter.app_count
        FROM contact_organizations
        RIGHT JOIN organizations
        ON contact_organizations.organization_id = organizations.organization_id
        INNER JOIN contacts
        ON contact_organizations.contact_id = contacts.contact_id    
        LEFT JOIN (
                SELECT
                    organizations.name AS name,
                    COUNT(applications.application_id) AS app_count
                FROM
                    contact_organizations
                INNER JOIN 
                    organizations
                ON 
                    contact_organizations.organization_id = organizations.organization_id
                LEFT JOIN
                    applications
                ON
                    contact_organizations.contact_organization_id = applications.contact_organization_id
                GROUP BY organizations.name
            ) AS app_counter
            ON organizations.name = app_counter.name"

        orgs = ActiveRecord::Base.connection.execute(orgs_query)
        return orgs
    end

    def self.delete_orgs_row_function(org_id, contact_id, contact_org_id)
        query = "
            DELETE FROM organizations 
            WHERE organization_id = #{org_id}
            "
        ActiveRecord::Base.connection.execute(query, org_id)

        query = "
            DELETE FROM contact_organizations 
            WHERE contact_organization_id = #{contact_org_id}
            "
        ActiveRecord::Base.connection.execute(query, contact_org_id)

        query = "
            DELETE FROM contacts 
            WHERE contact_id = #{contact_id}
            "
        ActiveRecord::Base.connection.execute(query, contact_id)
    end

    def self.add_table_entry_function(org_name, contact_name, contact_email, officer_position)
        
        org_count = Organization.count
        contact_count = Contact.count
        con_org_count = ContactOrganization.count
        org = {}
        contact = {}
        con_org = {}
        while Organization.where(organization_id: org_count).exists? do
            org_count = org_count + 1
        end
        while Contact.where(contact_id: contact_count).exists? do
            contact_count = contact_count + 1
        end
        while ContactOrganization.where(contact_organization_id: con_org_count).exists? do
            con_org_count = con_org_count + 1
        end

        org = Organization.create(organization_id: org_count, name: org_name, description: "None", created_at: "#{Date.today}", updated_at: "#{Date.today}")
        contact = Contact.create(contact_id: contact_count, year: Date.today, name: contact_name, email: contact_email, officer_position: officer_position, description: "None", created_at: "#{Date.today}", updated_at: "#{Date.today}")
        contact_organization = ContactOrganization.create(contact_organization_id: con_org_count, contact_id: contact_count, organization_id: org_count, created_at: "#{Date.today}", updated_at: "#{Date.today}")
    end

    def self.download_function(displayed_columns, not_filtered_out)

        # Create new excel workbook
        package = Axlsx::Package.new
        workbook = package.workbook
    
        worksheet = workbook.add_worksheet(name: 'Organizations')
    
        # worksheet.add_row @displayed_columns

        worksheet.add_row []
        row=worksheet.rows[0]
        rownum=1
        if displayed_columns.include?("Organization Name") then
            row.add_cell "Organization Name"
        end
        if displayed_columns.include?("Contact Name") then
            row.add_cell "Contact Name"
        end
        if displayed_columns.include?("Contact Email") then 
            row.add_cell "Contact Email"
        end
        if displayed_columns.include?("Officer Position") then
            row.add_cell "Officer Position"
        end
        if displayed_columns.include?("Last Modified") then
            row.add_cell "Last Modified Date"
        end
        if displayed_columns.include?("Applications") then
            row.add_cell "# Apps Per Organization"
        end

        not_filtered_out.each do |org_id|
            
            # default values
            contactName = "Not provided on STUACT website"
            contactEmail = "Not provided on STUACT website"
            officerPosition = "Not provided on STUACT website"
            updateYear = "Contact information was never entered"
            numApps = 0

            orgName = Organization.find_by(organization_id: org_id).name

            if ContactOrganization.where(organization_id: org_id).exists? then
                possible_contact_ids = ContactOrganization.select{|x| x[:organization_id] == org_id}.map{|y| y[:contact_id]}

                # Find number of applications with the contact_organization_id
                contact_org_ids = ContactOrganization.select{|x| x[:organization_id] == org_id}.map{|y| y[:contact_organization_id]}
                numApps = contact_org_ids.count

                possible_contact_ids.each do |n|
                    found_contact = Contact.find_by(contact_id: n)
                    contactName = found_contact.name
                    contactEmail = found_contact.email
                    officerPosition = found_contact.officer_position
                    updateYear = found_contact.year
        
                    worksheet.add_row []
                    row=worksheet.rows[rownum]
                    rownum=rownum+1
        
                    if displayed_columns.include?("Organization Name") then
                        row.add_cell orgName
                    end
                    if displayed_columns.include?("Contact Name") then
                        row.add_cell contactName
                    end
                    if displayed_columns.include?("Contact Email") then
                        row.add_cell contactEmail
                    end
                    if displayed_columns.include?("Officer Position") then
                        row.add_cell officerPosition
                    end
                    if displayed_columns.include?("Last Modified") then
                        row.add_cell updateYear
                    end
                    if displayed_columns.include?("Applications") then
                        row.add_cell numApps
                    end
                end
            end
        end

        # render xlsx: "download", filename: "included_stuff.xlsx"
        package.serialize 'included_items.xlsx'
    end
end
