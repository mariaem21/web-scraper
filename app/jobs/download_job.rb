require 'csv'
require 'date'

class DownloadJob < ApplicationJob
    queue_as :default

    def perform(text)
        filename = "new_file"
        orgTable = Organization.all;

        CSV.open("#{filename}.csv", "w") do |csv|
            csv << ["ID", "Student Organization", "Contact Name", "Contact Email", "Officer Position", "Last Modified", "Number of Apps Built"]
            
            # Loop through all organizations and add to CSV
            orgTable.each_with_index do |_org, index|
                orgid = Organization.find_by(organization_id: index).organization_id
                orgName = Organization.find_by(organization_id: index).name
                contactName = "Not provided on STUACT website"
                contactEmail = "Not provided on STUACT website"
                officerPosition = "Not provided on STUACT website"
                updateYear = "Contact information was never entered"
                appsBuilt = 0

                # Find contact associated with student org
                if Contact.where(organization_id: orgid).exists? then # There is a contact attributed to org, add to csv
                    contactName = Contact.find_by(organization_id: orgid).name # Name in database
                    contactEmail = Contact.find_by(organization_id: orgid).email # Name in database
                    officerPosition = Contact.find_by(organization_id: orgid).officer_position # Position in database
                    updateYear = Contact.find_by(organization_id: orgid).year # Last updated in database
                end

                csv << [orgid, orgName, contactName, contactEmail, officerPosition, updateYear, appsBuilt]
            end
        end
    end
end