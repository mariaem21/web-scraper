# require 'rubygems'
# require 'test/unit'
# require 'vcr'

# VCR.configure do |config|
#   config.cassette_library_dir = "spec/vcr_cassettes"
#   config.hook_into :webmock
#   config.configure_rspec_metadata!
# end

# class VCRTest < Test::Unit::TestCase
#   def test_example_dot_com
#     VCR.use_cassette("synopsis") do
#       response = Net::HTTP.get_response(URI('https://stuactonline.tamu.edu/app/search/index/index/q/a/search/letter'))
#       assert_match /Example domains/, response.body
#     end
#   end
# end