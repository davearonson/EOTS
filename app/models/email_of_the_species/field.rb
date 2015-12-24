class EmailOfTheSpecies::Field

  attr_reader :name, :label, :options, :supplement

  def initialize(name, label, options = {})
    # set display-size maxlength + 1 so user can SEE it all when full
    defaults = { :type => :text_field, :maxlength => 60, :style => "max-width: 100%", :size => 61 }
    @name = name
    @label = label
    @options = defaults.merge options
    @supplement = @options.delete :supplement
  end

  def html_on(form)
    type = options[:type]
    # Rails wants email_field(args), but HTML wants <input type="email">
    type = :email_field if type == :email
    form.send type, name, options
  end
end
