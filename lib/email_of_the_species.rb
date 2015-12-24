require "email_of_the_species/version"

module EmailOfTheSpecies

  # holds the field definitions of each class
  FIELDS = {}

  # to be used in routes.rb
  def self.declare_type(type)
    Rails.application.routes.draw do
      # TODO: normalize exposed url
      get "/contact/#{type}", :to => "email_of_the_species/email#show"
      post "/contact/#{type}", :to => "email_of_the_species/email#send"
    end
  end

end
