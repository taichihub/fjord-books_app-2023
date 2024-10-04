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
    time = Time.zone.parse('2024-09-10 10:00:00')
    report = Report.new(created_at: time)
    assert_equal time.to_date, report.created_on
  end

  test '#save_mentions' do
    def assert_mentions(report, expected_report_mentions)
      assert_equal report.mentioning_reports.map(&:id).sort, expected_report_mentions.map(&:id).sort
    end

    @user = users(:tanaka)
    @report_one = reports(:one)
    @report_two = reports(:two)
    @report_three = reports(:three)
    @report_four = reports(:four)

    # createテスト
    @report_one.save!
    @report_two.save!
    @report_three.save!

    assert_mentions(@report_one, [])
    assert_mentions(@report_two, [@report_one])
    assert_mentions(@report_three, [@report_one, @report_two])

    # updateテスト
    @report_one.update!(content: @report_four.content)
    assert_mentions(@report_one, [@report_two, @report_three])

    # destroyテスト
    @report_one.destroy!
    @report_two.reload
    assert_mentions(@report_two, [])
  end
end
