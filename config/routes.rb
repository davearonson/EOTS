EOTS::Engine.routes.draw do
  get "/:kind", :to => "eots#show"
  post "/:kind", :to => "eots#send_email"
end
