class EOTS::Field

  AlreadyDefinedError = Class.new(RuntimeError)
  InvalidSectionError = Class.new(RuntimeError)

  attr_reader :name, :label, :caption, :section, :html_options, :must_match

  def initialize(name, label, options={})
    @name = name.to_s
    @label = label
    opts = options.dup
    @caption = opts.delete(:caption)
    @section = opts.delete(:section) || :body
    @must_match = opts.delete(:must_match)
    unless [:header, :body, :footer].include? @section
      raise(InvalidSectionError,
            "Invalid section '#{@section}' -- must be :header, :body, or :footer")
    end
    apply_defaults(opts)
    @html_options = opts
  end

  def html(form)
    star = "* " if required?
    result = form.label_tag(name, "#{star}#{label}".html_safe)
    type = html_options[:type]
    if type.to_sym == :checkbox  # to_sym 'cuz it could be string or symbol
      result << form.content_tag(:span, " ")  # just to provide a spacer
      opts = html_options.dup
      checked = opts.delete :checked
      result << form.check_box_tag(name, name, checked, opts)
    else
      result << form.tag(:br)
      tag = "#{type}_field_tag".gsub("textarea_field", "text_area").to_sym
      result << form.send(tag, name, nil, html_options)
    end
    if caption
      result << form.tag(:br) 
      result << form.content_tag(:small, caption.html_safe)
    end
    result
  end

  def required?
    html_options[:required]
  end

  private

  def apply_defaults(opts)
    opts[:type] ||= :text
    case opts[:type].to_sym
    when :checkbox
      apply_check_box_defaults(opts)
    when :text, :email
      apply_text_defaults(opts)
    when :text_area
      apply_text_area_defaults(opts)
    end
  end

  def apply_check_box_defaults(opts)
    opts[:checked] = false unless opts.has_key?(:checked)
  end

  def apply_text_area_defaults(opts)
    cols = (opts[:cols] ||= 60)
    rows = (opts[:rows] ||= 5)
    opts[:maxlength] ||= cols * rows
  end

  def apply_text_defaults(opts)
    size = (opts[:size] ||= 60)
    opts[:maxlength] ||= size
  end

end
