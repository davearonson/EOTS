describe EOTS do

  describe "raises error" do
    it "on unknown name" do
      expect { EOTS::find_kind "nosuch" }.
        to raise_error EOTS::EmailKind::NotFoundError
    end

  end

end
