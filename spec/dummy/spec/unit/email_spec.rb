describe EOTS do

  describe "::Email" do

    before do
      EOTS::reset
      @kind = "whatever"
      EOTS::email_kind @kind, to: "wherever" do
        EOTS::field("name", "What is your name?", :required => true)
        EOTS::field("quest", "What is your quest?", :required => true)
        EOTS::field("color", "What is your favorite color?", :required => false)
      end
    end

    describe "#check_required_fields" do

      it "barfs if a required field is missing" do
        params = HashWithIndifferentAccess.new({ name:  "Sir Robin",
                                                 kind:  @kind })
        expect { EOTS::Email.create_from_params(params) }.
          to raise_error(EOTS::Email::MissingRequiredFieldsError)
      end

      it "does not barfs if no required fields are missing, even if optional field also missing" do
        params = HashWithIndifferentAccess.new({ name:  "Sir Robin",
                                                 quest: "Holy Grail",
                                                 kind:  @kind })
        expect { EOTS::Email.create_from_params(params) }.not_to raise_error
      end

    end

  end

end
