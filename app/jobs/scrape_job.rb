require 'open-uri'
require 'nokogiri'
require 'csv'
require 'date'

class ScrapeJob < ApplicationJob
    queue_as :default

    def perform(letters)

        letters.each do |letter|
            url = "https://stuactonline.tamu.edu/app/search/index/index/q/" + letter + "/search/letter"
            puts "#{url}"
            
            html = URI.open(url).read
            doc = Nokogiri::HTML(html)

            org_count = 1
            contact_count = 1
            con_org_count = 1
            org = {}
            contact = {}
            contact_org = {}

            job = {}
            job[:organization_id] = 0
            job[:name] = "NOT DONE"
            job[:description] = "The database is in the process of being updated. We're on letter #{letter}."

            if not Organization.where(organization_id: 0).exists? then
                Organization.where(job).first_or_create
            else 
                Organization.where(organization_id: 0).update(job)
            end

            doc.xpath("//big/a/@href").each do |element|
                element = element.text

                link_html = URI.open("#{element}").read
                link_doc = Nokogiri::HTML(link_html)

                # Gets the student organization name
                link_org = link_doc.xpath("//h1[@class = 'title']").text
            
                # Gets the contact name
                link_name = link_doc.xpath("//div[@class = 'form-view']/dl[2]/dd[1]").text

                # Gets the contact email
                link_email = link_doc.xpath("//div[@class = 'form-view']/dl[2]/dd[2]").text

                if (link_name == "") then
                    link_name = "empty"
                end
                if (link_email == "") then
                    link_email = "empty"
                end

                # If org already in database
                if Organization.where(name: link_org).exists? then

                    orgID_temp = Organization.find_by(name: link_org)

                    # If contact name is already there, it updates that contact
                        # Find all instances in contact_organizations with organization_id
                        # Loop through all, checking if the contact name matches
                    if ContactOrganization.where(organization_id: orgID_temp.organization_id).exists? && Contact.where(name: link_name).exists? then

                        possible_contact_ids = Contact.select{|x| x[:name] == link_name}.map{|y| y[:contact_id]}

                        if ContactOrganization.where(organization_id: orgID_temp.organization_id, contact_id: possible_contact_ids).exists? then
                            found_con_org = ContactOrganization.find_by(organization_id: orgID_temp.organization_id, contact_id: possible_contact_ids)
                            contact[:contact_id] = found_con_org.contact_id
                            contact[:year] = Date.today
                            contact[:name] = link_name
                            contact[:email] = link_email
                            contact[:officer_position] = "Not provided on the STUACT website"
                            contact[:description] = "Updating the existing contact information"
                            Contact.where(contact_id: found_con_org.contact_id, name: link_name).update(contact)
                        end
                
                    # If contact name does not exist, increments contact_count & con_org_count to free PK then creates contact & con_org
                    else
                        while Contact.where(contact_id: contact_count).exists? do
                            contact_count = contact_count + 1
                        end

                        # Increment id for contact_organization table too
                        while ContactOrganization.where(contact_organization_id: con_org_count).exists? do
                            con_org_count = con_org_count + 1
                        end

                        if !(link_name == "empty" && link_email == "empty") then
                            contact[:contact_id] = contact_count
                            contact[:year] = Date.today
                            contact[:name] = link_name
                            contact[:email] = link_email
                            contact[:officer_position] = "Not provided on the STUACT website"
                            contact[:description] = "Organization existed, but contact did not"
                            Contact.where(contact).first_or_create

                            # Make the contact_organization to link contact and org
                            contact_org[:contact_organization_id] = con_org_count
                            contact_org[:contact_id] = contact_count
                            contact_org[:organization_id] = orgID_temp.organization_id
                            ContactOrganization.where(contact_org).first_or_create
                        end
                    end
            
                # Org not already in database
                else
                    while Organization.where(organization_id: org_count).exists? do
                        org_count = org_count + 1
                    end
                    while Contact.where(contact_id: contact_count).exists? do
                        contact_count = contact_count + 1
                    end
                    while ContactOrganization.where(contact_organization_id: con_org_count).exists? do
                        con_org_count = con_org_count + 1
                    end

                    org[:organization_id] = org_count
                    org[:name] = link_org
                    org[:description] = "Organization not already in database"
                    Organization.where(org).first_or_create

                    if !(link_name == "empty" && link_email == "empty") then
                        contact[:contact_id] = contact_count
                        contact[:year] = Date.today
                        contact[:name] = link_name
                        contact[:email] = link_email
                        contact[:officer_position] = "Not provided on the STUACT website"
                        contact[:description] = "Contact information was not already in database"
                        Contact.where(contact).first_or_create

                        # Make the contact_organization to link contact and org
                        contact_org[:contact_organization_id] = con_org_count
                        contact_org[:contact_id] = contact_count
                        contact_org[:organization_id] = org_count
                        ContactOrganization.where(contact_org).first_or_create
                    end
                end
            end
        end

        puts "#{Organization.find_by(organization_id: 0).name}"
        updated_job = {}
        updated_job[:organization_id] = 0
        updated_job[:name] = "DONE"
        updated_job[:description] = "The database is not being updated."
        Organization.where(organization_id: 0).update(updated_job)
        puts "#{Organization.find_by(organization_id: 0).name}"
    end
end