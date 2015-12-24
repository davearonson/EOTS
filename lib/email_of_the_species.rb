require "email_of_the_species/engine"
require "email_of_the_species/version"

# WTF, WE SHOULDN'T HAVE TO DO THIS!
require_relative "../app/controllers/email_of_the_species/email_controller.rb"

module EmailOfTheSpecies


  # holds the field definitions of each class
  FIELDS = Hash.new { |h, k| h[k] = [] }

# # to be used in routes.rb
# def self.declare_type(type)
#   Rails.application.routes.draw do
#     # TODO: normalize exposed url
#     get "/contact/#{type}", :to => "email_of_the_species/email#show"
#     post "/contact/#{type}", :to => "email_of_the_species/email#send_email"
#   end
# end

end
