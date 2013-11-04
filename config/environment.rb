require "bundler/setup"

Bundler.require

DB = Sequel.connect("sqlite://#{Dir.pwd}/db/playlister.db")

require_relative '../app/models/song'
require_relative '../app/models/playlist'
require_relative '../app/models/voter'
# require_relative '../lib/spotify'
require_relative '../spotify-junk/spotify_moc'
require_relative '../app/controllers/application_controller'
require_relative '../app/controllers/playlist_controller'


#fancy way to load relatives --
# def load_dirs(array)
#   array.each do |dir|
#     Dir.entries(dir).each do |file|
#       next if file.start_with?(".") || file == 'application_controller.rb'
#       require_relative "../#{dir}/#{file}"
#     end
#   end
# end
