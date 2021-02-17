module RedmineMentions
  module MailerPatch
    def self.apply
      Mailer.class_eval do
        prepend InstanceMethods
      end unless Mailer < InstanceMethods
    end

    module InstanceMethods
      def notify_mentioning(user, issue, journal)
        @issue = issue
        @journal = journal
        @textnote = ActionView::Base.full_sanitizer.sanitize(journal.notes)
        mail(to: user.mail, subject: "[#{@issue.tracker.name} ##{@issue.id}] #{l(:mentioned_in)}: #{@issue.subject}")
      end
    end
  end
end
