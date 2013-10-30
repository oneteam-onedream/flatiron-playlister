class ApplicationController < Sinatra::Base

  set :views, File.expand_path('../../views', __FILE__)

    # A quick method to add all our app files to the reloader
  def self.reload_dirs(array)
    array.each do |dir|
      Dir.entries(dir).each do |file|
        next if file.start_with?(".")
        also_reload "./#{dir}/#{file}"
      end
    end
  end
  
  # Methods in controllers that aren't actions (endpoints for our routes)
  # should be made private.
  private_class_method :reload_dirs # This is native Ruby.
  
  # Configure Sinatra to reload directories like models and controllers.

  register Sinatra::Reloader
  reload_dirs ['app/models', 'app/controllers']

end