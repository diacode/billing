class InvoiceMailer < ActionMailer::Base
  default from: "billing@diacode.com"

  def send_email(invoice, recipient, message)
    @message = message
    attachments["#{invoice.to_s}.pdf"] = InvoicePdf.new(invoice).render
    mail(to: recipient, subject: invoice.to_s)
  end
end
