# frozen_string_literal: true

class ApplicationController < ActionController::Base
    before_action :authenticate_admin!
    after_action -> { flash.discard }, if: -> { request.xhr? }
end
