require 'bundler'
Bundler.require

class SpreadsheetsWrapper

  SHEET_KEY = ENV['SHEET_KEY']

  def initialize
    @session = GoogleDrive::Session.from_config("google_drive_config.json")
    @target_sheet = @session.spreadsheet_by_key(SHEET_KEY).worksheets[0]
  end

  def create_or_update_row_from_asana_task(asana_task)
    row = find_row_from_task_id
    params = sanitize_asana_task_to_params(asana_task)
    if row.nil?
      create_row(params)
    else
      update_row(params)
    end
  end

  # private

  def find_row_from_task_id(id)
    
  end

  def sanitize_asana_task_to_params(task)
    
  end

end