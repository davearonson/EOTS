class EmailOfTheSpecies::Field

  attr_reader :name, :label, :caption, :custom_error_message, :html_options

  def initialize(name, label, options = {})
    # set display-size maxlength + 1 so user can SEE it all when full
    defaults = { :type => :text_field, :maxlength => 40, :style => "max-width: 100%", :size => 40 }
    @name = name
    @label = label
    @caption = options.delete :caption
    @custom_error_message = options.delete :custom_error_message
    @html_options = defaults.merge(options)
  end

  def html_on(form)
    type = html_options[:type]
    # Rails wants email_field(args), but HTML wants <input type="email">
    type = :email_field if type == :email
    form.send type, name, html_options
  end
end
