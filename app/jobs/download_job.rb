require 'csv'
require 'date'

class DownloadJob < ApplicationJob
    queue_as :default

    def perform(text,exclude_orgid,exclude_orgname,exclude_contactname,exclude_contactemail,exclude_officer,exclude_date,exclude_appnum)
        filename = "new_file"
        orgTable = Organization.all;

        CSV.open("#{filename}.csv", "w") do |csv|
            csv << ["ID", "Student Organization", "Contact Name", "Contact Email", "Officer Position", "Last Modified", "Number of Apps Built"]
            
            # Loop through all organizations and add to CSV
            orgTable.each_with_index do |org, index|
                orgid = Organization.find_by(orgID: index).orgID
                orgName = Organization.find_by(orgID: index).name
                contactName = "Not provided on STUACT website"
                contactEmail = "Not provided on STUACT website"
                officerPosition = "Not provided on STUACT website"
                updateYear = "Contact information was never entered"
                appsBuilt = 0

                # Find contact associated with student org
                if Contact.where(orgID: orgid).exists? then #There is a contact attributed to org, add to csv
                    contactName = Contact.find_by(orgID: org.orgID).name #Name in database
                    contactEmail = Contact.find_by(orgID: org.orgID).email #Name in database
                    officerPosition = Contact.find_by(orgID: org.orgID).officerposition #Position in database
                    updateYear = Contact.find_by(orgID: org.orgID).year #Last updated in database
                end

                csv << [orgid, orgName, contactName, contactEmail, officerPosition, updateYear, appsBuilt]
            end
        end
    end
end