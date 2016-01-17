class EOTS::Mailer < ActionMailer::Base
  def email(msg)
    mail(from: msg.from,
         to: msg.to,
         cc: msg.cc,
         bcc: msg.bcc,
         reply_to: msg.reply_to,
         subject: msg.values[:subject],
         body: msg.body)
  end
end
