# frozen_string_literal: true

module ApplicationsHelper
    
    def sort_link_app(column:, label:, org_id:)
        if column == params[:column]
            link_to(label, list_applications_path(column: column, direction: next_direction, org_id: org_id))
        else
            link_to(label, list_applications_path(column: column, direction: 'asc', org_id: org_id))
        end
    end
        
    def next_direction
        params[:direction] == 'asc' ? 'desc' : 'asc'
    end

    def sort_indicator
        tag.span(class: "sort sort-#{params[:direction]}")
    end
    
end


