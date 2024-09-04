# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :report_mentions_as_mentioning, class_name: 'ReportMention', foreign_key: 'mentioning_report_id', dependent: :destroy, inverse_of: :mentioning_report
  has_many :mentioning_reports, through: :report_mentions_as_mentioning, source: :mentioned_report
  has_many :report_mentions_as_mentioned, class_name: 'ReportMention', foreign_key: 'mentioned_report_id', dependent: :destroy, inverse_of: :mentioned_report
  has_many :mentioned_reports, through: :report_mentions_as_mentioned, source: :mentioning_report

  validates :title, presence: true
  validates :content, presence: true

  REPORT_ID_URL = %r{http://localhost:3000/reports/(\d+)}

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_mentions
    report_mentions_as_mentioning.destroy_all
    mentioned_report_ids = content.scan(REPORT_ID_URL).flatten.map(&:to_i).uniq
    mentioned_report_ids.each do |mentioned_report_id|
      ReportMention.create(mentioning_report_id: id, mentioned_report_id:)
    end
  end
end
