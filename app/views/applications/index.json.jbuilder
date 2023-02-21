# frozen_string_literal: true

json.array! @applications, partial: 'applications/application', as: :application
