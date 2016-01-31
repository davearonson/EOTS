EOTS::email_kind "all", to: ENV["EMAIL_DESTINATION"] do

  EOTS::field(:name, "What is your name?", :section => :header,
              :required => true, :autofocus => true)

  EOTS::field(:email, "What is your email address?", :section => :header,
              :type => :email, :required => true,
              :caption => "Make sure this is correct, else I might not be able to contact you!")

  EOTS::field(:subject, "What is the subject?", :section => :header,
              :required => true)

  EOTS::field(:not_spambot, "I am not a spambot", :section => :footer,
              :type => :checkbox, :required => true,
              :custom_error => "You must tell me you are not a spambot")

  EOTS::footer "The questions marked with an asterisk (*) are required."

  EOTS::email_kind "general" do

    EOTS::header "You want to get in touch with me for some other reason?&nbsp; Okay."

    EOTS::field(:info, "What do you want to tell me (max 1000 characters)?",
                :required => true, :type => :textarea, :maxlength => 1000,
                :cols => 60, :rows => 20)

  end

  EOTS::email_kind "other" do

    EOTS::field(:other, "Anything else to tell or ask me?",
                :type => :textarea, :maxlength => 300,
                :cols => 60, :rows => 5, :section => :footer)

    EOTS::email_kind "list_signup" do

      EOTS::header "You want to be on my list of people to ping next time I'm coming available?&nbsp; Great!&nbsp; Just fill out this form."

      EOTS::field(:company, "What company are you representing?", :required => true)

      EOTS::field(:type, "Is that a staffing/recruiting firm, the end client, or what?",
                  :required => true)

      EOTS::field(:source, "Where did you hear about me?")

    end

    EOTS::email_kind "feedback" do

      EOTS::header "You want to give me some feedback?&nbsp; Great, that helps me improve, and serve you better.&nbsp; Embarassed?&nbsp; An email address is required... but if you want to be anonymous, nothing's forcing you to be truthful there...."

      EOTS::field(:how_i_did, "Overall, how did I do (max 300 characters)?",
                  :type => :textarea, :maxlength => 300,
                  :cols => 60, :rows => 5)

      EOTS::field(:liked, "What in particular did you really like (max 300 characters)?",
                  :type => :textarea, :maxlength => 300,
                  :cols => 60, :rows => 5)

      EOTS::field(:suggestions, "Any specific suggestions for improvement (max 300 characters)?",
                  :type => :textarea, :maxlength => 300,
                  :cols => 60, :rows => 5)

      EOTS::field(:quote, "Please give me a good quote I can use on my web site (max 300 characters):",
                  :type => :textarea, :maxlength => 300,
                  :cols => 60, :rows => 5)

      EOTS::field(:refer, "Who else you think would benefit from my services (max 300 characters)?",
                  :type => :textarea, :maxlength => 300,
                  :cols => 60, :rows => 5)

      EOTS::footer "Thank you very much, and please recommend me to your friends!"

    end

    EOTS::email_kind "hire_me" do

      # TODO: figure out a way to stick rails paths in the text!
      EOTS::header "You want to hire me for a project?&nbsp; Great!&nbsp; (If it isn't one I'd be interested in, but you want my help finding someone, please see the <a href=\"/contact/referral_request\">referral request page</a>.)&nbsp; This web site should answer most of your questions, but I have many for you.&nbsp; Let's get some of the usual ones out of the way."

      EOTS::field(:location, "Where is the work to be done?", :required => true,
                  :caption => "I only work remotely, or within about 15 miles of Fairfax City, VA")

      EOTS::field(:length, "How long is this engagement for?", :required => true,
                  :caption => "I accept engagements from one week to one year")

      EOTS::field(:per_week, "About how many hours a week do you need from me?",
                  :required => true,
                  :caption => "I generally work up to about 30-35 hours a week, "\
                  "but will do 40 hour weeks briefly")

      EOTS::field(:type, "What types of arrangement are acceptable?", :required => true,
                  :caption => "E.g., temp-W2, 1099, or non-corp B2B; I don't do \"permanent\" and am not incorporated")

      EOTS::field(:reqs, "What skills are required (and at what level(s))?",
                  :required => true,
                  :caption => "See the Technologies page for what I will do, and be realistic")

      EOTS::field(:bonuses, "What other skills would be helpful?")

      EOTS::field(:dev_kind, "Is this new development, bugfixes, adding features, or what?")

      EOTS::field(:purpose, "What is the project intended to accomplish?")

      EOTS::field(:biz_purpose, "Why -- i.e., what is the business value?")

      EOTS::field(:environment,
                  "What are the tools, processes, and other environmental factors?",
                  :type => :textarea, :maxlength => 300,
                  :cols => 60, :rows => 5)

      EOTS::field(:company,
                  "What can you tell me about the company?",
                  :type => :textarea, :maxlength => 300,
                  :cols => 60, :rows => 5,
                  :caption => "I understand third party recruiters won't want to reveal the client, but the industry, age, and size would be useful")

      EOTS::field(:teamsize_then, "How big is the team going to be?")

      EOTS::field(:teamsize_now, "How big is the team already?")

      EOTS::field(:rate, "What rate are you willing to pay?",
                  :caption => "Include whether that's W2, 1099, or B2B.  Sorry to get mercenary about it so quickly, but we can save a lot of time by finding out ASAP how much overlap our ranges have.")

    end

    EOTS::email_kind "referral_request" do

      EOTS::header "You're a recruiter, you have an opening, and you know it's not one I'm interested in, but you want my help finding people, right?&nbsp; Sure.&nbsp; Just fill out this form."

      EOTS::field(:skills, "What skills do you need (and at what level(s))?",
                  :required => true)

      EOTS::field(:location, "Where is the work to be done?", :required => true,
                  :caption => "Please be as precise as possible")

      EOTS::field(:type, "What types of arrangement are acceptable?", :required => true,
                  :caption => "E.g., permanent, temp-W2, 1099, C2C, non-corp B2B, CTH, TTP, etc.")

      EOTS::field(:rate, "What rate/salary are you willing to pay?", :required => true)

    end

    EOTS::email_kind "subcontract_request" do

      EOTS::header "You want me to subcontract work to you?&nbsp; Probably not.&nbsp; I only subcontract to people whose work I know well, and most of my subcontract requests are from people I've never even heard of.&nbsp; If we really do know each other, go ahead and fill out this form.&nbsp; Otherwise, please don't waste both my time and yours."

      EOTS::field(:skills, "What skills do you have (and at what level(s))?",
                  :required => true)

      EOTS::field(:location, "Where are you located?", :required => true)

      EOTS::field(:turf, "Where are you willing to work?", :required => true)

      EOTS::field(:rate, "What rate do you need?", :required => true)

      EOTS::field(:biz_kind, "What type of business you have?",
                  :required => true,
                  :caption => "E.g., sole proprietor, partnership, LLC, corporation")

      EOTS::field(:jurisdiction, "Where is your business located, for legal purposes?",
                  :required => true,
                  :caption => "E.g., maybe you live in CA but your biz is organized in DE")

    end


  end
end
