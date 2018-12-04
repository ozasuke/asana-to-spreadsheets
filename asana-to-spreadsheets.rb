require 'bundler'
require './spreadsheets_wrapper'
Bundler.require

class AsanaToSpreadsheets
  ACCESS_TOKEN = ENV['ASANA_ACCESS_TOKEN']

  def initialize
    @spread_sheets = SpreadsheetsWrapper.new
    @client = Asana::Client.new do |c|
      c.authentication :access_token, ACCESS_TOKEN
    end
    @workspace = @client.workspaces.find_all.first
  end

  def run
    tactics_list_projects = get_tactics_list_projects
    tactics_list_projects.each do |project|
      p "project.name:#{project.name}"
      target_tasks = select_target_tasks(project)
      target_tasks.each do |task|
        p "task.name:#{task.name}"
        @spread_sheets.create_or_update_row_from_asana_task(task)
      end 
      p '-------------------------------'
    end
  end

  private

  def get_tactics_list_projects
    opt = {fields: ['color', 'id', 'name', 'notes']}
    all_projects = @client.projects.find_all(workspace: @workspace.id, archived: false, per_page: 100, options: opt)
    all_projects.select do |project|
      project.color == 'dark-brown'
    end
  end

  def select_target_tasks(project)
    sections = @client.sections.find_by_project(project: project.id)
    target_sections = sections.select{|section| section.name.include?('実施決定') }
    target_sections.map do |section|
      @client.tasks.find_by_section(section: section.id, per_page: 100).to_a
    end.flatten
  end

  def self.run(*args)
    new(*args).run
  end
end

AsanaToSpreadsheets.run
