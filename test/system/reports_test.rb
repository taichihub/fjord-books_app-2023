# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  def setup
    @user = users(:tanaka)
    @report = reports(:one)
    @edit_report = reports(:two)
  end

  test 'log_in_and_write_edit_destroy_report' do
    # ログイン
    visit new_user_session_path
    fill_in 'Eメール', with: @user.email
    fill_in 'パスワード', with: 'password'
    click_on 'ログイン'
    assert_text 'ログインしました。'

    # 日報作成
    visit new_report_path
    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_on '登録する'
    assert_text '日報が作成されました。'

    # 日報編集
    visit edit_report_path(id: @report.id)
    fill_in 'タイトル', with: @edit_report.title
    fill_in '内容', with: @edit_report.content
    click_on '更新する'
    assert_text '日報が更新されました。'

    # 日報削除
    visit report_path(@edit_report.id)
    click_on 'この日報を削除'
    assert_text '日報が削除されました。'
  end
end
