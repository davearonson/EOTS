class EOTS::Email  # an instance, as opposed to the whole kind

  MissingRequiredFieldsError = Class.new(RuntimeError)

  attr_reader :kind, :values

  EOTS::STANDARD_FIELDS.each do |field|
    define_method(field) { kind.send field || values[:name] }
  end

  def initialize(kind, values={})
    @kind = kind
    @values = values.dup
  end

  def self.create_from_params(params)
    kind_name = params[:kind]
    kind = EOTS::find_kind(kind_name)
    unless kind
      raise(EOTS::EmailKind::NotFoundError,
            "Unknown email kind '#{kind_name}': #{list}")
    end
    # TEMPORARY KLUGE, UNTIL I MAKE THE VALUES A SUB-HASH:
    values = params.dup
    %w(action controller authenticity_token commit kind utf8).each { |k| values.delete k }
    check_value_names(values, kind) if values.any?
    check_required_fields(values, kind)
    self.new(kind, values)
  end

  def body
    parts = [kind.name.titleize]
    kind.form_fields.values.flatten.each do |field|
      parts << "> #{"* " if field.required?}#{field.label}"
      reply = values[field.name]
      parts << (reply.present? ? reply : "(not answered)")
    end
    parts.join("\n\n")
  end

  def from
    kind.from || "\"#{values[:name]}\" <#{values[:email]}>"
  end

  private

  def self.check_required_fields(values, kind)
    required = kind.form_fields.values.flatten.select { |f| f.required? }.map(&:name)
    puts "required: #{ required.map { |n| "#{n} (#{n.class.name})" }.join(", ") }"
    given = values.keys
    puts "given: #{ given.map { |n| "#{n} (#{n.class.name})" }.join(", ") }"
    missing = required - given
    if missing.any?
      raise(MissingRequiredFieldsError,
            "Missing required field(s) #{missing.sort.to_sentence}")
    end
  end

  def self.check_value_names(values, kind)
    field_names = kind.form_fields.values.flatten.map &:name
    errs = values.keys.reject { |key| field_names.include? key }
    if errs.any?
      list = errs.map { |e| "'#{e}'" }.join(", ")
      raise(EOTS::EmailKind::FieldNotFoundError,
            "Field(s) not found on email kind '#{kind.name}': #{list}")
    end
  end

end
