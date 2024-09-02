# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    ActiveRecord::Base.transaction do
      @report = current_user.reports.new(report_params)

      if @report.save
        create_mentions(@report)
        redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
      else
        render :new, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      if @report.update(report_params)
        create_mentions(@report)
        redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
      else
        render :edit, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  end

  def destroy
    @report.destroy
    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def create_mentions(report)
    report.report_mentions_as_mentioning.destroy_all
    mentioned_report_ids = Report.extract_mentioned_report_ids(report.content).uniq
    mentioned_report_ids.each do |mentioned_report_id|
      ReportMention.create(mentioning_report_id: report.id, mentioned_report_id: mentioned_report_id)
    end
  end
end
