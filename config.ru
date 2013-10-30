# Load our environment.
require './config/environment'

# A method to quickly mount all our Controllers as Middleware
# def mount_controllers_as_middleware
#   Dir.entries('app/controllers').each do |file|
#     next if file.start_with?(".") || file == "application_controller.rb"
#     controller_name = file.split("_controller").first.capitalize

#     use Kernel.const_get("#{controller_name}Controller")
#   end
# end
# mount_controllers_as_middleware

use Rack::Static, :root => 'public', :urls => ['/img', '/css', '/js']

# Mount the main controller as our Rack Application.
use FrankController
run ApplicationController