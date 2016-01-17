describe EOTS::EmailKind do

  before do
    EOTS::reset
  end

  let(:bcc) { "This is the bcc" }
  let(:cc) { "This is the cc" }
  let(:footer1) { "This is Footer 1" }
  let(:footer2) { "This is Footer 2" }
  let(:footer3) { "This is Footer 3" }
  let(:from) { "This is the from" }
  let(:header1) { "This is Header 1" }
  let(:header2) { "This is Header 2" }
  let(:header3) { "This is Header 3" }
  let(:kind1) { "kind1" }
  let(:kind2) { "kind2" }
  let(:kind3) { "kind3" }
  let(:reply_to) { "This is the reply_to" }
  let(:to) { "This is the to" }


  describe "creates" do


    it "an item at the top level" do
      EOTS::email_kind kind1

      expect(EOTS::find_kind(kind1)).not_to be_nil
    end


    it "an item at the current non-top level" do
      EOTS::email_kind kind1 do
        EOTS::email_kind kind2
      end

      expect(EOTS::find_kind(kind1).parent).to be_nil
      expect(EOTS::find_kind(kind2).parent.name).to eq kind1
    end


    it "multiple items at top level" do
      EOTS::email_kind kind1
      EOTS::email_kind kind2 { EOTS::email_kind kind3 }

      expect(EOTS::find_kind(kind1).parent).to be_nil
      expect(EOTS::find_kind(kind2).parent).to be_nil
    end


    it "multiple items at a lower level" do
      EOTS::email_kind kind1 do
        EOTS::email_kind kind2
        EOTS::email_kind kind3
      end

      expect(EOTS::find_kind(kind1).parent).to be_nil
      expect(EOTS::find_kind(kind2).parent.name).to eq kind1
      expect(EOTS::find_kind(kind3).parent.name).to eq kind1
    end


    it "more at current level after going down" do
      EOTS::email_kind kind1 do
        EOTS::email_kind kind2
      end
      EOTS::email_kind kind3

      expect(EOTS::find_kind(kind1).parent).to be_nil
      expect(EOTS::find_kind(kind2).parent.name).to eq kind1
      expect(EOTS::find_kind(kind3).parent).to be_nil
    end


  end


  it "records additional options passed in" do
    EOTS::email_kind(kind1, foo: :bar, baz: "quux", wocka: 3.14159)

    t1 = EOTS::find_kind kind1
    expect(t1.options).to eq({ foo: :bar, baz: "quux", wocka: 3.14159 })
  end


  it "records headers and footers passed in" do
    EOTS::email_kind kind1 do
      EOTS::header header1
      EOTS::footer footer1
    end

    t1 = EOTS::find_kind kind1
    expect(t1.header).to eq header1
    expect(t1.footer).to eq footer1
  end


  it "accumulates headers in the right order, with both syntaxes" do
    EOTS::email_kind(kind1, header: header1)  do
      EOTS::email_kind kind2 do
        EOTS::header header2
        EOTS::email_kind kind3 do
          EOTS::header header3
        end
      end
    end

    expect(EOTS::find_kind(kind3).headers).to eq [header1, header2, header3]
  end


  it "accumulates fields in the right order" do
    EOTS::email_kind kind1 do
      EOTS::field "header_field1", nil, section: :header
      EOTS::field "field1", nil
      EOTS::field "footer_field1", nil, section: :footer
      EOTS::email_kind kind2 do
        EOTS::field "header_field2", nil, section: :header
        EOTS::field "field2", nil
        EOTS::field "footer_field2", nil, section: :footer
        EOTS::email_kind kind3 do
          EOTS::field "header_field3", nil, section: :header
          EOTS::field "field3", nil
          EOTS::field "footer_field3", nil, section: :footer
        end
      end
    end

    fields = EOTS::find_kind(kind3).form_fields
    expect(fields[:header].map(&:name)).to eq ["header_field1", "header_field2", "header_field3"]
    expect(fields[:body  ].map(&:name)).to eq ["field1", "field2", "field3"]
    expect(fields[:footer].map(&:name)).to eq ["footer_field3", "footer_field2", "footer_field1"]
  end


  it "accumulates footers in the right order, with both syntaxes" do
    EOTS::email_kind kind1, footer: footer1 do
      EOTS::email_kind kind2 do
        EOTS::footer footer2
        EOTS::email_kind kind3 do
          EOTS::footer footer3
        end
      end
    end

    expect(EOTS::find_kind(kind3).footers).to eq [footer3, footer2, footer1]
  end


  EOTS::STANDARD_FIELDS.each do |field|

    it "consults super for #{field} if not specified" do
      value = "This is the #{field}"
      EOTS::email_kind kind1, field => value do
        EOTS::email_kind kind2
      end

      expect(EOTS::find_kind(kind2).send field).to eq value
    end


    it "can override #{field}" do
      old_value = "This is the old #{field}"
      new_value = "This is the new #{field}"
      EOTS::email_kind kind1, field => old_value do
        EOTS::email_kind kind2, field => new_value
      end

      expect(EOTS::find_kind(kind2).send field).to eq new_value
    end


    it "can take #{field} as a method (vs in options hash)" do
      value = "This is the #{field}"
      EOTS::email_kind kind1 do
        EOTS.send field, value
      end

      expect(EOTS::find_kind(kind1).send field).to eq value
    end


  end

  describe "raises error" do

    it "on duplicate name at same level" do
      EOTS::email_kind "dup"

      expect {
        EOTS::email_kind "dup"
      }.to raise_error EOTS::EmailKind::AlreadyDefinedError
    end


    it "on duplicate name at different levels" do
      EOTS::email_kind kind1

      EOTS::email_kind kind2 do
        expect {
          EOTS::email_kind kind1
        }.to raise_error EOTS::EmailKind::AlreadyDefinedError
      end
    end

  end

end
