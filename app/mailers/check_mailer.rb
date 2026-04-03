# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def failure_mail(check)
    @check = check
    @repository = check.repository
    @user = @repository.user

    mail(to: @user.email, subject: t('.subject', repo: @repository.name))
  end
end
