require 'bundler'
Bundler.require

class SpreadsheetsWrapper

  SHEET_KEY = ENV['SHEET_KEY']
  TASK_ID_COL_NUM = 1

  def initialize
    @session = GoogleDrive::Session.from_config("google_drive_config.json")
    @sheet = @session.spreadsheet_by_key(SHEET_KEY).worksheets[1]
  end

  def create_or_update_row_from_asana_task(asana_task)
    row_num = find_row_from_task_id(1)
    params = sanitize_asana_task_to_params(asana_task)
    if row_num.nil?
      p "#{asana_task.name}を新規追加"
      save_row!(params, new_row_num)
    else
      p "#{asana_task.name}を更新"
      save_row!(params, row_num)
    end
  end

  private

  def find_row_from_task_id(id)
    task_ids.find_index(id)
  end

  def save_row!(params, row_num)
    @sheet.reload
    params.each do |col_num, v|
      @sheet[row_num, col_num.to_i] = v
    end
    @sheet.save
  end

  def new_row_num
    @sheet.num_rows + 1
  end

  def sanitize_asana_task_to_params(task)
    {
      TASK_ID_COL_NUM.to_s => task.id,
      '2' => task.name,
    }
  end

  def task_ids
    @sheet.rows.map{|r| r[TASK_ID_COL_NUM - 1] }
  end

end