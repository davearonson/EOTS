class EmailOfTheSpecies::Email

  def initialize(hash={})
    self.class.fields.each do |field|
      key = field.name
      val = hash[key]
      self.public_send("#{key}=", val) if val.present?
    end
  end

  def body
    parts = { :body => [self.class.name.titleize.gsub(/ Email\Z/, "")] }
    self.class.fields.each do |f|
      section = f[:section] || :body
      parts[section] ||= []
      parts[section] << "> #{"* " if f.options[:required]}#{f.label}"
      reply = self.public_send f.name
      parts[section] << (reply.present? ? reply : "(not answered)")
    end
    (parts[:body] + parts[:footer]).join("\n\n")
  end

  # front-end requirements SHOULD make this redundant, BUT....
  # TODO MAYBE: check formatting?
  def errors
    errs = []
    klazz.fields.each do |field|
      next unless field.options[:required]
      next if self.send(field.name).present?
      if field.custom_error_message
        errs << field.custom_error_message
      else
        need_an_n = %w(a e i o u).include? field.name.to_s.split("").first
        errs <<  "You must supply a#{"n" if need_an_n} #{field.name}"
      end
    end
    errs
  end

  def self.field(name, label, options = {})
    EmailOfTheSpecies::FIELDS[self] << EmailOfTheSpecies::Field.new(name, label, options)
    attr_accessor name
  end

  def self.fields
    all_fields = EmailOfTheSpecies::FIELDS[self] || []
    all_fields.unshift(superclass.fields) if(superclass.is_a?(EmailOfTheSpecies::Email))
    all_fields
  end

  # needed for some form magic
  def self.model_name
    name
  end

end
