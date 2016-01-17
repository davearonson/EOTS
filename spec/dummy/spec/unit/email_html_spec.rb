describe EOTS do

  before do
    EOTS::reset
  end

  let(:field1) { :field1 }
  let(:field2) { :field2 }
  let(:field3) { :field3 }
  let(:footer1) { "This is Footer 1" }
  let(:footer2) { "This is Footer 2" }
  let(:footer3) { "This is Footer 3" }
  let(:header1) { "This is Header 1" }
  let(:header2) { "This is Header 2" }
  let(:header3) { "This is Header 3" }
  let(:label1) { "This is Label 1" }
  let(:label2) { "This is Label 2" }
  let(:label3) { "This is Label 3" }
  let(:kind1) { :kind1 }
  let(:kind2) { :kind2 }
  let(:kind3) { :kind3 }

  describe "#email_html" do

    it "outputs headers, fields, and footers in correct order" do
      skip
      EOTS::email_kind kind1 do
        EOTS::header header1
        EOTS::field field1, label1
        EOTS::footer footer1
        EOTS::email_kind kind2 do
          EOTS::header header2
          EOTS::field field2, label2
          EOTS::footer footer2
          EOTS::email_kind kind3 do
            EOTS::header header3
            EOTS::field(field3, label3)
            EOTS::footer footer3
          end
        end
      end

      regex = /#{header1}.*#{header2}.*#{header3}.*#{label1}.*#{label2}.*#{label3}.*#{footer3}.*#{footer2}.*#{footer1}/m
      expect(EOTS::email_html(kind3)).to match(regex)
    end

  end

end
