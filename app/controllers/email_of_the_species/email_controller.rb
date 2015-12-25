class EmailOfTheSpecies::EmailController < ActionController::Base

  before_action :create_email

  def send_email
    return false unless validate_email
    Emailer.email(@email).deliver
    redirect_to root_path, notice: 'Your email has been sent'
  end

  def show
    render :show
  end

  private

  # TODO: FILTER WITH STRONG PARAMS!
  def create_email
    @email, errs = EmailOfTheSpecies::Email.create_from_params(params)
    flash_errors(errs)
  end

  def flash_errors(errs)
    return true if errs.nil? || errs.none?
    flash.now[:alert] = errs.join("\n")
    redirect_to root_path
    false
  end

  def validate_email
    missing_fields = @email.missing_fields
    flash_errors(missing_fields)
  end

end
