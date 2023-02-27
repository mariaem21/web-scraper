require 'open-uri'
require 'nokogiri'
require 'csv'
require 'date'

# class ScraperSpider
def scraping(url)
    puts "HERE"
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

        orgcount = orgcount + 1
        contactcount = contactcount + 1
        # if !Organization.where(orgID: self.orgID).exists? then
        #     errors.add(:orgID, 'Must have a valid organization ID.')
        # end
        if Organization.where(name: link_org).exists? then
            # puts "Org #{link_org} already exists"
            contact[:personID] = contactcount
            contact[:orgID] = orgcount
            contact[:year] = Date.today
            contact[:name] = link_name
            contact[:email] = link_email
            contact[:officerposition] = "empty"
            contact[:description] = "empty"
            Contact.where(orgID: orgcount).update(contact)
            # con.update(:personID => self.personID, :orgID => self.orgID, :year => Date.today, :name => link_name, :email =>link_email, :officerposition => self.officerposition, :description => "EDITED")
        else
            # puts "Org #{link_org} does not already exist"
            while Organization.where(orgID: orgcount).exists? do
                orgcount = orgcount + 1
            end
            while Contact.where(personID: contactcount).exists? do
                contactcount = contactcount + 1
            end
            org[:orgID] = orgcount
            org[:name] = link_org
            org[:description] = "None"

            contact[:personID] = contactcount
            contact[:orgID] = orgcount
            contact[:year] = Date.today
            contact[:name] = link_name
            contact[:email] = link_email
            contact[:officerposition] = "empty"
            contact[:description] = "empty"

            Organization.where(org).first_or_create
            Contact.where(contact).first_or_create
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

    def update
        respond_to do |format|
            if @contact.update(contact_params)
                format.html { redirect_to contact_url(@contact), notice: 'Contact was successfully updated.' }
                format.json { render :show, status: :ok, location: @contact }
            else
                format.html { render :edit, status: :unprocessable_entity }
                format.json { render json: @contact.errors, status: :unprocessable_entity }
            end
        end
    end

    def contact_params
        params.require(:contact).permit(:personID, :orgID, :year, :name, :email, :officerposition, :description)
    end
end
    
    scraping("https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter")
# end