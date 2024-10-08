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
    user = users(:tanaka)
    report_one = reports(:one)
    report_one.content = "メンション先なし"
    report_two = reports(:two)
    report_two.content = "http://localhost:3000/reports/1"
    report_three = reports(:three)
    report_three.content = "http://localhost:3000/reports/1 http://localhost:3000/reports/2"

    # createテスト
    report_one.save!
    report_two.save!
    report_three.save!

    assert_same_elements(report_one.mentioning_reports, [])
    assert_same_elements(report_two.mentioning_reports, [report_one])
    assert_same_elements(report_three.mentioning_reports, [report_one, report_two])

    # updateテスト
    report_one.update!(content: "http://localhost:3000/reports/2 http://localhost:3000/reports/3")
    assert_same_elements(report_one.mentioning_reports, [report_two, report_three])

    # destroyテスト
    report_one.destroy!
    report_two.reload
    assert_same_elements(report_two.mentioning_reports, [])
  end
end
