yarn add @hotwired/turbo-rails
yarn run build
bundle add cssbundling-rails jsbundling-rails
rails javascript:install:webpack
rails css:install:tailwind
release: rails db:migrate && rails db:seed
worker: rake jobs:work