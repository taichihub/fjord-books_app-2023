# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @user = users(:tanaka)
    @report_one = reports(:one)
    @report_two = reports(:two)
    @report_three = reports(:three)
  end

  test '#editable?' do
    user = User.new
    report = Report.new(user:)
    assert report.editable?(user)

    another_user = User.new
    assert_not report.editable?(another_user)
  end

  test '#created_on' do
    time = Time.zone.parse('2024-09-10 10:00:00')
    report = Report.new(created_at: time)
    assert_equal time.to_date, report.created_on
  end

  test '#save_mentions' do
    def assert_mentions(report, expected_report_mentions)
      actual_mentions = report.mentioning_reports.map(&:id).sort
      expected_mentions = expected_report_mentions.map(&:id).sort
      assert_equal expected_mentions, actual_mentions
    end

    @report_one.save!
    @report_two.save!
    @report_three.save!

    assert_mentions(@report_one, [])
    assert_mentions(@report_two, [@report_one])
    assert_mentions(@report_three, [@report_one, @report_two])
  end
end
