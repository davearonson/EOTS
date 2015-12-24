class EmailOfTheSpecies::EmailController < ActionController::Base

  def send
    # TODO: FILTER WITH STRONG PARAMS!
    klazz = params[:type].titleize.constantize
    return unless klazz < EmailOfTheSpecies::Email
    email = klazz.new(email_params)
    # front-end requirements SHOULD make this redundant, BUT....
    errs = email.errors
    if errs.any?
      flash.now[:alert] = errs.join("\n")
      return false
    end
    Emailer.email(email).deliver
    redirect_to root_path, notice: 'Your email has been sent'
  end

  def show
    render(params[:type])
  end

end
