require 'rails_helper'

describe EOTS::EOTSController, type: :request do


  let(:inner_body_field_label)   { "This is the inner body field label" }
  let(:inner_footer)             { "This is the inner footer" }
  let(:inner_footer_field_label) { "This is the inner footer field label" }
  let(:inner_header)             { "This is the inner header" }
  let(:inner_header_field_label) { "This is the inner header field label" }
  let(:inner_kind)               { "inner_kind" }
  let(:outer_body_field_label)   { "This is the outer body field label" }
  let(:outer_footer)             { "This is the outer footer" }
  let(:outer_footer_field_label) { "This is the outer footer field label" }
  let(:outer_header)             { "This is the outer header" }
  let(:outer_header_field_label) { "This is the outer header field label" }
  let(:outer_kind)               { "outer_kind" }

  describe "#show" do

    it "shows a simple email, with parts in order" do
      EOTS::email_kind outer_kind, header: outer_header, footer: outer_footer do
        EOTS::field "whatever1", outer_header_field_label, section: :header
        EOTS::field "whatever2", outer_body_field_label
        EOTS::field "whatever3", outer_footer_field_label, section: :footer
        EOTS::email_kind inner_kind, header: inner_header, footer: inner_footer do
          EOTS::field "whatever4", inner_header_field_label, section: :header
          EOTS::field "whatever5", inner_body_field_label
          EOTS::field "whatever6", inner_footer_field_label, section: :footer
        end
      end

      get "/contact_emails/#{inner_kind}"  # eots is mounted at /contact_emails

      expect(response.status).to eq 200
      expected_stuff = ("#{outer_header}.*"\
                        "#{inner_header}.*"\
                        "#{outer_header_field_label}.*"\
                        "#{inner_header_field_label}.*"\
                        "#{outer_body_field_label}.*"\
                        "#{inner_body_field_label}.*"\
                        "#{inner_footer_field_label}.*"\
                        "#{outer_footer_field_label}.*"\
                        "#{inner_footer}.*"\
                        "#{outer_footer}")
      expect(response.body).to match /#{expected_stuff}/m
    end

  end

end
