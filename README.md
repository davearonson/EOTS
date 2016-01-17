# EOTS

EOTS stands for Email Of The Species.  It is a mountable Rails engine that lets
you define a hierarchy of kinds (species) of fillable forms to be emailed to
you.  EOTS will take care of generating views, accepting posted
values, and sending the email.


## API

There are two main calls you need to be familiar with:


### `EOTS::email_kind(name, options={}, &block)`

Use `EOTS::email_kind` to declare a new kind of email.  The name may be any
type, but will be converted to a string, so that when the form is asked for or
submitted, it will match the param.

Recognized options are:

- `header`: a string that will be displayed above the form
- `footer`: a string that will be displayed below the form
- Any of the following standard email fields:
  - `from`
  - `to`
  - `reply-to`
  - `cc`
  - `bcc`
  - `subject`

You can also specify any of them _within_ the block supplied to
`EOTS::email_kind`, using methods such as `EOTS::header`, `EOTS::from`,
etc.  These will overwrite any such options already defined on the _current_
email kind being defined.  Standard email fields will be _inherited_ by any
subtypes of the current email type.  Headers will be printed in forward order
in the hierarchy, and footers in reverse; see the "Form Order" section for an
example.


Attempting to redefine an existing email kind will cause an
`EOTS::EmailKind::AlreadyDefinedError` error.

You generally will want to supply a block to this, because that's where you'll
define the _fields_ on this kind of email, using:


### `EOTS::field(name, label, options={})`

Again, the name may be a string or symbol or whatever, but will be stored as a
string, for param matching.  Options are:

- `caption`: anything you want to appear in small text underneath the field

- `section`: to move this to the top, middle, or bottom section of the form.
  Valid values are `:header`, `:body` (default), and `:footer`.  As with the
  headers and footers on the email as a whole, `:header` fields are shown from
  general to specific (as are `:body` fields), and `:footer` fields are the
  other way around.

- any others you wish to put in the HTML, such as a type, id, class, default
  value, maximum length, etc.  If you use `required: true`, not only will the
  user be required to put a value in the field (or check the box; no, I don't
  have a required-UNchecked at this time), but also its label will be preceded
  by an asterisk (\*).  You may want to mention that fact in a footer.

The fields are shown on the form in this order:

- `:header` fields, from most general to most specific
- `:body` fields, from most general to most specific
- `:footer` fields, from most specific to most general

Within each section, they are shown in the order in which they were defined.
Again, see the "Form Order" section for an example.

I have tested it so far with these kinds of fields:

- checkbox
- email (default size and maxlength of 60)
- text (ditto)
- textarea (default 60 cols by 5 rows and maxlength 300)

Attempting to redefine an existing field _on the same email kind_ will cause an
`EOTS::Field::AlreadyDefinedError` error.


## Showing the Form

EOTS is a "mountable engine".  That means that in your `config/routes.rb`, you
must specify a "mount point" for it, such as: `mount EOTS::Engine =>
"/contact"`.  Each type of email you define (regardless of the level of
hierarchy) will be at a URL beneath that, corresponding to its name.  For
instance, with the route and hierarchy above, they will be at
`/contact/general` and `/contact/specific`.

At this time, those are not actual route table entries.  EOTS uses the URL
`/:kind` to get Rails to stick the "kind" in the `params`.  So, if you wanted
to construct the URL, such as for use in a `link_to`, you'd have to tack the
email kind name onto `eots_path`, such as `"#{eots_path}/general"`.

The form will be shown in your default layout.  You can change that by copying
the EOTS controller and tweaking it there.  If there is demand, maybe I can add
an option to say what layout a form should be shown on.


## Form Order

Suppose you defined the following email kinds:

```
EOTS::email_kind("general",
                 to: "general@example.com",
                 bcc: "records@example.com",
                 header: "General Header",
                 footer: "Aaaaaaaaaaaaargh!!") do
  EOTS::field("name", "What is your name?",
              section: :header, required: true)
  EOTS::field("email", "What is your email address?",
              type: :email, section: :header, required: true)
  EOTS::field("else", "Anything else to tell us?",
              type: :textarea, section: :footer)
  EOTS::field("human", "Are you a real human?",
              type: :checkbox, section: :footer, required: true)
  EOTS::email_kind("bridge",
                   header: "Who would cross the Bridge of Death must answer me these questions three, ere the other side he see.") do
    EOTS::field("quest", "What is your quest?", required: true)
    EOTS::email_kind("for-lancelot",
                     to: "holy-grail@example.com",
                     footer: "I think you're gonna get this right.") do
      EOTS::field("color", "What is your favorite color?",
                  required: true)
    end
    EOTS::email_kind("for-robin",
                     to: "pit@example.com",
                     footer: "Ha, good luck, sucker!") do
      EOTS::field("capital", "What is the capital of Assyria?", required: true)
    end
    EOTS::email_kind("for-arthur",
                     to: "holy-grail@example.com",
                     footer: "Right this way, my liege!") do
      EOTS::field("capital", "What is the air-speed velocity of an unladen swallow?",
                  required: true)
    end
  end
end
```

and ask for EOTS to show the form for a `for-robin` email.  The form will have these parts:

- General Header
- Who would cross the Bridge of Death must answer me these questions three, ere the other side he see.
- \* What is your name?
- text entry box for that, marked required
- \* What is your email address?
- text entry box for that, marked required, hinting mobile devices to use a keyboard layout appropriate for email addresses, and with basic email validation applied before submission
- \* What is the capital of Assyria?
- text entry box for that, marked required
- Anything else to tell us?
- textarea for that, NOT marked required
- \* Are you a real human?
- checkbox for that, marked required
- Send button
- Ha, good luck, sucker!
- Aaaaaaaaaaaaargh!!

When this form is submitted, the email will be sent to `specific@example.com`,
since that email kind's definition overrode the `general` kind's `to` option.
However, since the `bcc` was not overridden, `records@example.com` will still
be bcc'ed.

## Accepting the Filled-In Form

Don't worry, EOTS has that covered.

However, at this time it does _not_ set up your credentials and email processor
and such.  You must still do that yourself, in the
`ActionMailer::Base.smtp_settings` section of `config/environment.rb` (or
whatever you use).


## Recommendations

- Start with a type called `:all` or some such thing, that contains the fields
  (as `:header`) that you're going to want on _all_ emails, like the sender's
  name, email address, and maybe a Subject line.  Then get specialized,
  dividing into divergent kinds where needed.  For instance, to have the name,
  email address, and subject fields at the top of all forms, and a checkbox
  about them not being a spambot at the bottom of all forms, and a freeform
  textbox just above that with slightly different wording if that's the only
  other field, and always a note at the bottom about required fields, you could
  do something like this:

```
  EOTS::email_kind("all",
                   footer: "Required fields are marked with an asterisk (*)") do
    EOTS::field("name", "What is your name?",
                section: :header, required: true, autofocus: true)
    EOTS::field("email", "What is your email address?",
                type: :email, section: :header, required: true)
    EOTS::field("subject", "What are you contacting us about?",
                section: :header, required: true)
    EOTS::field("not_bot", "You are not a spambot",
                type: :checkbox, required: true)
    EOTS::email_kind "general" do
      EOTS::field("info", "What do you want to say to us?",
                  type: :textarea, required: true)
    end
    EOTS::email_kind "specific" do
      EOTS::field("info", "Do you have anything else to say to us?",
                  type: :textarea, section: :footer required: true)
      EOTS::email_kind "compliment" do
        EOTS::header "Someone really made your day?  We're glad to hear it!"
        EOTS::field "person", "Who should we heap praises upon?", required: true
        EOTS::field("why", "What did they do to make you so happy?",
                    type: :textarea, required: true)
      end
      EOTS::email_kind "complaint" do
        EOTS::header "We're sorry you're not satisfied.  Please give us a chance to set things right."
        EOTS::field("object", "What product, service, person, etc. are you having problems with?",
                    required: true)
        EOTS::field("problem", "What problem are you experiencing?",
                    type: :textarea, required: true, rows: 10)
        EOTS::field("followup", "Would you like us to contact you about this?",
                    type: :checkbox)
      end
    end
  end
```

- The obvious place to put this setup is in `config/initializers/eots.rb`.


## Ideas

Things I have in mind to do eventually:

- Let you specify what layout a form should be shown on

- Let you specify what URL to redirect to upon submitting a form
