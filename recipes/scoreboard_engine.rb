##
# API servce
#

services = node["htc"]["services"] || [ "api" ]
Chef::Log.info( "SERVICES: %s" % services.inspect )

runit_service "cloudrim-scoreboard" do
  log false
  if(services.include?( "scoreboard" ))
    action [ :enable, :start ]
  else
    action [ :disable, :down, :stop ]
  end
end

