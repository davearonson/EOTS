require "eots/engine"

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "EOTS"
end

module EOTS

  # standard fields you'd see in any email
  STANDARD_FIELDS = %i(from to reply_to cc bcc subject)

  # need a better short name for this... stuff we want to let the dev pass in
  # the email_kind declaration, either as an option or in the block, other than
  # fields....
  NON_FIELD_ITEMS = %i(header footer)

  def self.email_kind(name, options={}, &block)
    kind = create_email_kind(name, options)
    @@kind_stack.push kind
    yield if block_given?
    @@kind_stack.pop
  end

  def self.field(name, label, options={})
    @@kind_stack.last.add_field(name, label, options)
  end

  def self.find_kind(kind_name)
    kind = @@kind_hash[kind_name]
    unless kind
      raise(EOTS::EmailKind:: NotFoundError,
            "Unknown email kind '#{kind_name}'")
    end
    kind
  end

  (STANDARD_FIELDS + NON_FIELD_ITEMS).each do |field|
    define_singleton_method field do |value|
      @@kind_stack.last.send "#{field}=".to_sym, value
    end
  end

  private

  # declare/init innards this way so we can reset them in tests
  def self.reset
    @@kind_stack = []
    @@kind_hash = {}
  end
  self.reset

  def self.create_email_kind(name, options)
    raise(EmailKind::AlreadyDefinedError, "Email kind #{name} is already defined") if @@kind_hash[name]
    @@kind_hash[name] = EOTS::EmailKind.new(name, @@kind_stack.last, options)
  end

end
