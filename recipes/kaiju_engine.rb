##
# API servce
#

services = node["htc"]["services"] || [ "api" ]
Chef::Log.info( "SERVICES: %s" % services.inspect )

runit_service "cloudrim-kaiju" do
  log false
  if(services.include?( "kaiju" ))
    action [ :enable, :start ]
  else
    action [ :disable, :down, :stop ]
  end
end

