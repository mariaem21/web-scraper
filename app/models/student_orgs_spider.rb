require 'open-uri'
require 'nokogiri'
require 'csv'

def scraping(url)
    html = URI.open("https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter").read
    doc = Nokogiri::HTML(html)
    
    @items = []
    @studentOrgs = []
    @links = []
    @emails = []
    @names = []

    value = {}

    doc.xpath("//big/a/@href").each do |element|
        element = element.text
        @links << element

        link_html = URI.open("#{element}").read
        link_doc = Nokogiri::HTML(link_html)

        link_org = link_doc.xpath("//h1[@class = 'title']").text
        puts "#{link_org}"
        @studentOrgs << link_org
        
        link_name = link_doc.xpath("//div[@class = 'form-view']/dl[2]/dd[1]").text
        puts "#{link_name}"
        @names << link_name

        link_email = link_doc.xpath("//div[@class = 'form-view']/dl[2]/dd[2]").text
        puts "#{link_email}"
        @emails << link_email

        value[:name] = link_org
        value[:email] = link_email
        value[:full_name] = link_name
        StudentOrg.where(value).first_or_create
    end

    # Print out names for debugging purposes
    # @names.each_with_index do |element, index|
    #     puts "#{index + 1} - #{element}"
    # end

    # Send info to CSV file
    filename = "test_file"
    CSV.open("#{filename}.csv", "w") do |csv|
        csv << ["Org Name", "Link", "Contact Name", "Contact Email"] 
        [@items, @links, @names, @emails].transpose.each do |row|
            csv << row
        end
    end
end

scraping("https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter")
