require 'bundler'
Bundler.require

GoogleDrive::Session.from_config("google_drive_config.json")