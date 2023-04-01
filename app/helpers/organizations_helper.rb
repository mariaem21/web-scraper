# frozen_string_literal: true

module OrganizationsHelper
    
    def sort_link(column:, label:)
        if column == params[:column]
            link_to(label, list_organizations_path(column: column, direction: next_direction))
        else
            link_to(label, list_organizations_path(column: column, direction: 'ASC'))
        end
    end
        
    def next_direction
        params[:direction] == 'ASC' ? 'DESC' : 'ASC'
    end
    
end


