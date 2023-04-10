bundle add cssbundling-rails jsbundling-rails
rails javascript:install:webpack
rails css:install:tailwind
rails hotwire:install
release: rails db:migrate && rails db:seed
worker: rake jobs:work