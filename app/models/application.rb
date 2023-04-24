# frozen_string_literal: true

class Application < ApplicationRecord
    validates :application_id, presence: true, uniqueness: true, comparison: { greater_than: -1 }
    validates :contact_organization_id, presence: true, comparison: { greater_than: -1 }
    validates :name, presence: true
    validates :date_built, presence: true
    validates :github_link, presence: true
    validates :description, presence: true

    # def organization_id_exists
    #     if !Organization.where(organization_id: self.organization_id).exists? then
    #         errors.add(:organization_id, 'Must have a valid organization ID.')
    #     end
    # end

    def self.delete_apps_row_function(app_id, application_category_id)
        query = "
            DELETE FROM applications 
            WHERE applications.application_id = #{app_id}
            "
        ActiveRecord::Base.connection.execute(query)

        # query = "
        #     DELETE FROM contact_organizations 
        #     WHERE contact_organizations.contact_organization_id = #{contact_org_id}
        #     "
        # ActiveRecord::Base.connection.execute(query)

        # query = "
        #     DELETE FROM contacts 
        #     WHERE contacts.contact_id = #{contact_id}
        #     "
        # ActiveRecord::Base.connection.execute(query)

        if application_category_id and application_category_id != ""
            query = "
                DELETE FROM application_categories 
                WHERE application_categories.application_category_id = #{application_category_id}
            "    
            ActiveRecord::Base.connection.execute(query)
        end
    end

    def self.add_table_entry_function(organization_id, contact_name, contact_email, officer_position, app_name, date_built, github_link, category, notes)
        
        app_count = Application.count
        contact_count = Contact.count
        con_org_count = ContactOrganization.count
        cat_count = Category.count
        app_cat_count = ApplicationCategory.count
        app = {}
        contact = {}
        con_org = {}

        while Contact.where(contact_id: contact_count).exists? do
            contact_count = contact_count + 1
        end
        while ContactOrganization.where(contact_organization_id: con_org_count).exists? do
            con_org_count = con_org_count + 1
        end
        while Application.where(application_id: app_count).exists? do
            app_count = app_count + 1
        end
        while Category.where(category_id: cat_count).exists? do
            cat_count = cat_count + 1
        end
        while ApplicationCategory.where(application_category_id: app_cat_count).exists? do
            app_cat_count = app_cat_count + 1
        end

        contact = Contact.create(contact_id: contact_count, year: Date.today, name: contact_name, email: contact_email, officer_position: officer_position, description: "None", created_at:Date.today, updated_at: Date.today)
        contact_organization = ContactOrganization.create(contact_organization_id: con_org_count, contact_id: contact_count, organization_id: organization_id, created_at: Date.today, updated_at: Date.today)
        app = Application.create(application_id: app_count, contact_organization_id: con_org_count, name: app_name, date_built: date_built, github_link: github_link, description: notes, created_at: Date.today, updated_at: Date.today)
        cat = Category.create(category_id: cat_count, name: category, description: 'None', created_at: Date.today, updated_at: Date.today)
        app_cat = ApplicationCategory.create(application_category_id: app_cat_count, application_id: app_count, category_id: cat_count, created_at: Date.today, updated_at: Date.today)

    end
end
