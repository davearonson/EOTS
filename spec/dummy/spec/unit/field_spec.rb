describe EOTS do

  before do
    EOTS::reset
  end

  let(:kind_name_1)  { "kind1" }
  let(:kind_name_2)  { "kind2" }
  let(:kind_name_3)  { "kind3" }
  let(:field_name_1) { "field1" }
  let(:field_name_2) { "field2" }
  let(:field_name_3) { "field3" }
  let(:label_1)      { "This is the label for field 1" }
  let(:label_2)      { "This is the label for field 2" }
  let(:label_3)      { "This is the label for field 3" }

  describe "#field" do

    it "attaches a field to the current email kind" do
      EOTS::email_kind(kind_name_1) { EOTS::field field_name_1, label_1 }

      fields = EOTS::find_kind(kind_name_1).fields
      expect(fields.map { |name, obj| [name, obj.label] }).to eq [[field_name_1, label_1]]
    end


    it "can accomodate multiple email kinds" do
      EOTS::email_kind(kind_name_1) { EOTS::field(field_name_1, label_1) }
      EOTS::email_kind kind_name_2 do
        EOTS::field field_name_2, label_2
        EOTS::field field_name_3, label_3
      end

      expect(EOTS::find_kind(kind_name_1).fields.map { |name, obj|
        [name, obj.label]
      }).to eq([[field_name_1, label_1]])
      expect(EOTS::find_kind(kind_name_2).fields.map { |name, obj|
        [name, obj.label]
      }).to eq([[field_name_2, label_2], [field_name_3, label_3]])
    end


    it "barfs on same field on same email kind" do
      expect {
        EOTS::email_kind kind_name_1 do
          EOTS::field field_name_1, label_1
          EOTS::field field_name_1, label_1
        end
      }.to raise_error(EOTS::Field::AlreadyDefinedError)
    end


    it "does not barf on same field on different email kinds" do
      EOTS::email_kind(kind_name_1) { EOTS::field(field_name_1, label_1) }

      expect {
        EOTS::email_kind(kind_name_2) { EOTS::field(field_name_1, label_1) }
      }.not_to raise_error
    end

  end

end
