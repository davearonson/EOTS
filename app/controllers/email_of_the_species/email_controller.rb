class EmailOfTheSpecies::EmailController < ActionController::Base

  def send_email
    Emailer.email(email).deliver if create_email && validate_email
    redirect_to root_path, notice: 'Your email has been sent'
  end

  def show
    if create_email
      render :show
    else
      redirect_to root_path
    end
  end

  private

  def create_email
    # TODO: FILTER WITH STRONG PARAMS!
    @type = params[:type]
    errs = nil
    msg = "Invalid email type #{@type}"
    begin
      klazz = "#{@type.camelize}Email".constantize
    rescue
      errs ||= [msg]
    end
    unless (klazz < EmailOfTheSpecies::Email)
      errs ||= [msg]
      @email = klazz.new(email_params)
    end
    flash_errors(errs)
  end

  def flash_errors(errs)
    return true if errs.nil? || errs.none?
    flash.now[:alert] = errs.join("\n")
    false
  end

  def validate_email
    errs = @email.errors
    flash_errors(errs)
  end

end
