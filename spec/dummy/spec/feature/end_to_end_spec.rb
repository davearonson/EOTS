describe EOTS do

  before do

    EOTS::email_type("top_level",
                     header: "Thank you for contacting us.",
                     footer: "We will contact you back as soon as possible.") do


      EOTS::field("name", "What is your name?", section: :header,
                  columns: 60, maxlength: 60)

      EOTS::field("email", "What is your email address?", type: :email,
                  section: :header, columns: 60, maxlength: 60,
                  caption: "Make sure this is right or I won't be able to contact you!")

      EOTS::field("not_spambot", "I am not a spambot", type: :checkbox,
                  section: :footer)

      EOTS::email_type("general") do
        EOTS::field("body", "What do you want to tell or ask us?",
                    type: :textarea, rows: 5, columns: 60, maxlength: 1024,
                    caption: "Maximum 1k of text")
      end

      EOTS::email_type("non_general") do

        EOTS::field("body", "Anything else to tell or ask us?", type: :textarea)

        EOTS::email_type("sales_inquiry",
                         header: "We look forward to serving you!",
                         footer: "Thank you for your patronage!") do

          EOTS::field("product", "What product number are you interested in?",
                      columns: 60, maxlength: 60)

          EOTS::field("quantity", "How many would you like?", type: :number,
                      min: 0)

          EOTS::field("payment_type", "How would you like to pay for that?",
                      type: :select, options: [:Cash, :Credit])

        end

        EOTS::email_type("customer service inquiry",
                         header: "We're sorry you're not 100% satisfied.",
                         footer: "We'll do all we can to make things right.") do

          EOTS::field("name", "What product are you having a problem with?",
                      columns: 60, maxlength: 60,
                      caption: "Please include the product number if you can")

          EOTS::field("name", "What is the problem?",
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

end
