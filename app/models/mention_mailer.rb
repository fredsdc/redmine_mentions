class MentionMailer < ActionMailer::Base
  include ApplicationHelper
  layout 'mailer'
  default from: Setting.mail_from
  def self.default_url_options
    Mailer.default_url_options
  end
  
  
  def notify_mentioning(issue, journal, user)
    @issue = issue
    @journal = journal
    @htmlnote = textilizable(journal.notes)
    @textnote = ActionView::Base.full_sanitizer.sanitize(@htmlnote)
    mail(to: user.mail, subject: "[#{@issue.tracker.name} ##{@issue.id}] You were mentioned in: #{@issue.subject}")
  end
end
