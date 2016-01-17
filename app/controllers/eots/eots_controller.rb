module EOTS

  class EOTSController < ApplicationController

    include Rails.application.routes.url_helpers

    before_action :get_view_context

    def show
      # TODO: make this just get the KIND
      @kind = EOTS::find_kind(params[:kind])
      render :show
    end

    def send_email
      @email, errs = EOTS::Email.create_from_params(params)
      if errs && errs.any?
        flash.now[:alert] = errs.join("\n")
        redirect_to request.url, request.params
      end
      EOTS::Mailer.email(@email).deliver_now
      redirect_to root_path, notice: 'Your email has been sent'
    end

    private

    def get_view_context
      @view_context = view_context
    end

  end

end
