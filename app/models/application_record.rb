require 'open-uri'
require 'nokogiri'
require 'csv'
require 'date'

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  def scraping(url)
    html = URI.open("https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter").read
    doc = Nokogiri::HTML(html)
    
    @items = []
    @studentOrgs = []
    @links = []
    @emails = []
    @names = []
    orgcount = 0
    contactcount = 0

    org = {}
    contact = {}

    doc.xpath("//big/a/@href").each do |element|
        element = element.text
        @links << element

        link_html = URI.open("#{element}").read
        link_doc = Nokogiri::HTML(link_html)

        link_org = link_doc.xpath("//h1[@class = 'title']").text
        # puts "#{link_org}"
        @studentOrgs << link_org
        
        link_name = link_doc.xpath("//div[@class = 'form-view']/dl[2]/dd[1]").text
        # puts "#{link_name}"
        @names << link_name

        link_email = link_doc.xpath("//div[@class = 'form-view']/dl[2]/dd[2]").text
        # puts "#{link_email}"
        @emails << link_email

        # orgcount = orgcount + 1
        # contactcount = contactcount + 1
        if (link_name == "") then
            link_name = "empty"
        end
        if (link_email == "") then
            link_email = "empty"
        end

        # If org already in database
        if Organization.where(name: link_org).exists? then
            # puts "Org #{link_org} already exists"

            orgID_temp = Organization.find_by(name: link_org)
            # puts "orgID #{orgID_temp}"

            # If contact name is already there, it updates that contact
            if Contact.where(orgID: orgID_temp.orgID, name: link_name).exists? then
                contact[:personID] = Contact.find_by(orgID: orgID_temp.orgID, name: link_name).personID
                contact[:orgID] = orgID_temp.orgID
                contact[:year] = Date.today
                contact[:name] = link_name
                contact[:email] = link_email
                contact[:officerposition] = "Both org and contact name existed"
                contact[:description] = "Updating the contact information"
                # puts "Contact: #{contact}"
                Contact.where(orgID: orgID_temp.orgID, name: link_name).update(contact)
            
            # If contact name does not exist, increments contactcount to free PK then creates contact
            else
                while Contact.where(personID: contactcount).exists? do
                    contactcount = contactcount + 1
                end
                if !(link_name == "empty" && link_email == "empty") then
                    contact[:personID] = contactcount
                    contact[:orgID] = orgID_temp.orgID
                    contact[:year] = Date.today
                    contact[:name] = link_name
                    contact[:email] = link_email
                    contact[:officerposition] = "Org existed, but contact did not"
                    contact[:description] = "empty"
                    # puts "Contact: #{contact}"
                    Contact.where(contact).first_or_create
                end
            end
        
        # Org not already in database
        else
            while Organization.where(orgID: orgcount).exists? do
                orgcount = orgcount + 1
            end
            while Contact.where(personID: contactcount).exists? do
                contactcount = contactcount + 1
            end
            org[:orgID] = orgcount
            org[:name] = link_org
            org[:description] = "Org not already in database"
            # puts "Org: #{org}"
            Organization.where(org).first_or_create

            if !(link_name == "empty" && link_email == "empty") then
                contact[:personID] = contactcount
                contact[:orgID] = orgcount
                contact[:year] = Date.today
                contact[:name] = link_name
                contact[:email] = link_email
                contact[:officerposition] = "not in database"
                contact[:description] = "neither name or email are empty"
                # puts "Contact: #{contact}"
                Contact.where(contact).first_or_create
            end
        end
    end

    # Send info to CSV file
    filename = "test_file"
    CSV.open("#{filename}.csv", "w") do |csv|
        csv << ["Org Name", "Link", "Name", "Email"] 
        [@studentOrgs, @links, @names, @emails].transpose.each do |row|
            csv << row
        end
    end
  end
end
