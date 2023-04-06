# frozen_string_literal: true

module OrganizationsHelper
    
    def sort_link(column:, label:)
        if column == params[:column]
            link_to(label, list_organizations_path(column: column, direction: next_direction))
        else
            link_to(label, list_organizations_path(column: column, direction: 'asc'))
        end
    end
        
    def next_direction
        params[:direction] == 'asc' ? 'desc' : 'asc'
    end

    def sort_indicator
        tag.span(class: "sort sort-#{params[:direction]}")
    end
end
