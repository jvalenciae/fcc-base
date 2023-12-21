# frozen_string_literal: true

class ImportMailer < ApplicationMailer
  def students(user, total_entries, success_entries, failed_entries, csv_name, attachments)
    to = user.email
    substitutions = {
      subject: I18n.t('mailer.import.students'),
      totas_entries: total_entries,
      success_entries: success_entries,
      failed_entries: failed_entries,
      csv_name: csv_name
    }
    template_id = 'd-ab4500a861954219977f0ddfbbf2e132'
    MailerService.mail(to, substitutions, template_id, attachments)
  end
end
