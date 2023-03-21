require 'open-uri'
require 'nokogiri'
require 'csv'
require 'date'

class ScrapeJob < ApplicationJob
    queue_as :default

    after_perform do |job|
        Organizations.notify_organization_processed(job.arguments.first)
        # respond_to do |format|
        #     format.html { redirect_to organizations_url, notice: 'All organizations and contacts were successfully updated.' }
        #     format.json { head :no_content }
        # end
    end

    around_perform do |job, block|
        respond_to do |format|
            format.html { redirect_to organizations_url, notice: 'Not finished updating. Thank you for your patience.' }
            format.json { head :no_content }
        end
    end

    def perform(url)
        html = URI.open("https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter").read
        doc = Nokogiri::HTML(html)

        org_count = 0
        contact_count = 0
        org = {}
        contact = {}

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
                if Contact.where(organization_id: orgID_temp.organization_id, name: link_name).exists? then
                    contact[:contact_id] = Contact.find_by(organization_id: orgID_temp.organization_id, name: link_name).contact_id
                    contact[:organization_id] = orgID_temp.organization_id
                    contact[:year] = Date.today
                    contact[:name] = link_name
                    contact[:email] = link_email
                    contact[:officer_position] = "Both org and contact name existed"
                    contact[:description] = "Updating the contact information"
                    Contact.where(organization_id: orgID_temp.organization_id, name: link_name).update(contact)
            
                # If contact name does not exist, increments contactcount to free PK then creates contact
                else
                    while Contact.where(contact_id: contact_count).exists? do
                        contact_count = contact_count + 1
                    end
                    if !(link_name == "empty" && link_email == "empty") then
                        contact[:contact_id] = contact_count
                        contact[:organization_id] = orgID_temp.organization_id
                        contact[:year] = Date.today
                        contact[:name] = link_name
                        contact[:email] = link_email
                        contact[:officer_position] = "Org existed, but contact did not"
                        contact[:description] = "empty"
                        Contact.where(contact).first_or_create
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
                org[:organization_id] = org_count
                org[:name] = link_org
                org[:description] = "Org not already in database"
                Organization.where(org).first_or_create

                if !(link_name == "empty" && link_email == "empty") then
                    contact[:contact_id] = contact_count
                    contact[:organization_id] = org_count
                    contact[:year] = Date.today
                    contact[:name] = link_name
                    contact[:email] = link_email
                    contact[:officer_position] = "not in database"
                    contact[:description] = "neither name or email are empty"
                    Contact.where(contact).first_or_create
                end
            end
        end
    end
end