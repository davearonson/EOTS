class EOTS::EmailKind

  AlreadyDefinedError = Class.new(RuntimeError)
  FieldNotFoundError = Class.new(RuntimeError)
  NotFoundError = Class.new(RuntimeError)

  attr_accessor :fields, :name, :parent, :options

  EOTS::STANDARD_FIELDS.each do |field|
    attr_writer field
    define_method field do
      instance_variable_get("@#{field}".to_sym) || parent.try(field)
    end
  end

  EOTS::NON_FIELD_ITEMS.each { |field| attr_accessor field }

  def initialize(name, parent, options={})
    @name = name.to_s
    opts = options.dup
    @fields = {}
    (EOTS::STANDARD_FIELDS + EOTS::NON_FIELD_ITEMS).each do |field|
      instance_variable_set("@#{field}".to_sym, opts.delete(field))
    end
    @options = opts  # what's left
    @parent = parent
  end

  def add_field(field_name, label, field_options)
    field_name = field_name.to_s
    if @fields[field_name]
      raise(EOTS::Field::AlreadyDefinedError,
            "Field #{field_name} is already defined on email kind #{self.name}")
    end
    @form_fields = nil # invalidate it... can't reach down to children tho :-(
    # also return the new field, in case caller wants to do something with it
    @fields[field_name] = EOTS::Field.new(field_name, label, field_options)
  end

  def body_fields
    form_fields[:body]
  end

  def footer_fields
    form_fields[:footer]
  end

  def footers
    below = @parent ? @parent.footers : []
    ([footer] + below).compact
  end

  def form_fields
    unless @form_fields
      @form_fields = @parent ? @parent.form_fields : { header: [], body: [], footer: [] }
      mine = fields.values.group_by &:section
      @form_fields[:header] += mine[:header] if mine[:header]
      @form_fields[:body]   += mine[:body]   if mine[:body]
      @form_fields[:footer]  = mine[:footer] + @form_fields[:footer] if mine[:footer]
    end
    @form_fields.dup  # dup so children don't add stuff
  end

  def header_fields
    form_fields[:header]
  end

  def headers
    above = @parent ? @parent.headers : []
    (above << header).compact
  end

  def html_footers
    wrap_in_html_paragraphs(footers)
  end

  def html_headers
    wrap_in_html_paragraphs(headers)
  end

  private

  def wrap_in_html_paragraphs(stuff)
    if stuff.any?
      "#{stuff.map { |thing| "<p>#{thing}</p>" }.join("\n")}<br/>".html_safe
    end
  end

end
