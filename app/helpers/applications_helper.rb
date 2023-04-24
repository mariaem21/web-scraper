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

    def check_app_param(id)
        if cookies[:applications_ids] != nil
            if cookies[:applications_ids].include?(id.to_s)
                return true
            else
                return false
            end
        else
            return false
        end
    end

    def check_app_session_exists(value, string)
        if value != nil
            return value[string]
        else
            return ""
        end
    end
end