describe EOTS do

  before do

    EOTS::reset

    EOTS::email_kind("top_level",
                     header: "Thank you for contacting us.",
                     footer: "We will contact you back as soon as possible.") do


      EOTS::field("name", "What is your name?", section: :header,
                  columns: 60, maxlength: 60)

      EOTS::field("email", "What is your email address?", type: :email,
                  section: :header, columns: 60, maxlength: 60,
                  caption: "Make sure this is right or I won't be able to contact you!")

      EOTS::field("not_spambot", "I am not a spambot", type: :checkbox,
                  required: true,
                  section: :footer)

      EOTS::email_kind("general") do
        EOTS::field("body", "What do you want to tell or ask us?",
                    type: :textarea, rows: 5, columns: 60, maxlength: 1024,
                    caption: "Maximum 1k of text")
      end

      EOTS::email_kind("non_general") do

        EOTS::field("body", "Anything else to tell or ask us?", type: :textarea)

        EOTS::email_kind("sales_inquiry",
                         header: "We look forward to serving you!",
                         footer: "Thank you for your patronage!") do

          EOTS::field("product", "What product number are you interested in?",
                      columns: 60, maxlength: 60)

          EOTS::field("quantity", "How many would you like?", type: :number,
                      min: 0)

          EOTS::field("payment_type", "How would you like to pay for that?",
                      type: :select, options: [:Cash, :Credit])

        end

        EOTS::email_kind("customer service inquiry",
                         header: "We're sorry you're not 100% satisfied.",
                         footer: "We'll do all we can to make things right.") do

          EOTS::field("product", "What product are you having a problem with?",
                      columns: 60, maxlength: 60,
                      caption: "Please include the product number if you can")

          EOTS::field("problem", "What is the problem?",
                      type: :textarea, rows: 5, columns: 60, maxlength: 1024,
                      caption: "Maximum 1k of text")

        end

      end

    end

  end

  describe "#list" do
    it "lists all valid email types, with their descriptions, and no invalid email types"
  end

  describe "#show" do
    it "shows a top-level email type"
    it "shows a second-level email type"
    it "shows a third-level email type with nil in the middle"
    it "shows headers, footers, and fields in proper order"
    it "shows text fields correctly"
    it "shows text area fields correctly"
    it "shows checkboxes correctly"
    it "shows integer fields correctly"
    it "shows select fields correctly"
    it "shows captions correctly"
    it "enforces minimums on integers correctly"
    it "enforces maximums on integers correctly"
  end

  describe "#send_email" do
    describe "checks requiredness of fields" do
      it "barfs if any are missing" do
        params = HashWithIndifferentAccess.new({ kind: "general" })
        expect { EOTS::Email.create_from_params(params) }.
          to raise_error(EOTS::Email::MissingRequiredFieldsError)
      end
      it "doesn't barfs if all are supplied" do
        params = HashWithIndifferentAccess.new({ kind: "general",
                                                 not_spambot: true })
        expect { EOTS::Email.create_from_params(params) }.not_to raise_error
      end
    end
  end

end
