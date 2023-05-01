bundle add cssbundling-rails jsbundling-rails
rails javascript:install:webpack
rails css:install:tailwind
release:rails db:drop && rails db:create && rails db:migrate && rails db:seed
worker: rake jobs:work
