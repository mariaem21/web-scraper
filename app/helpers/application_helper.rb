# frozen_string_literal: true

module ApplicationHelper
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
end
