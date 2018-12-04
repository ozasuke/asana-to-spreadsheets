require 'bundler'
require './spreadsheets_wrapper'
Bundler.require

class AsanaToSpreadsheets

  def initialize
    @spread_sheets = SpreadsheetsWrapper.new
  end

  def run
    tactics_list_projects = get_tactics_list_projects
    tactics_list_projects.each do |project|
      p "project.name:#{project.name}"
      target_tasks = select_target_tasks(project)
      target_tasks.each do |task|
        p "task.name:#{task.name}"
        SpreadsheetsWrapper.create_or_update_rows_from_asana_task(task)
      end
      p '-------------------------------'
    end
  end

  # private

  def get_tactics_list_projects
    
  end

  def select_target_tasks(project)
    
  end

  def self.run(*args)
    new(*args).run
  end
end

AsanaToSpreadsheets.run
