Rails.application.routes.draw do
  get "/contact/:type", :to => "email_of_the_species/email#show"
  post "/contact/:type", :to => "email_of_the_species/email#send_email"
end
