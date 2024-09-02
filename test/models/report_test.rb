# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  test '#editable?' do
    user = User.new
    report = Report.new(user:)
    assert report.editable?(user)

    another_user = User.new
    assert_not report.editable?(another_user)
  end

  test '#created_on' do
    report = Report.new(created_at: Time.zone.now)
    assert_equal report.created_at.to_date, report.created_on
  end
end
