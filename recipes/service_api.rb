##
# API servce
#

services = node["htc"]["services"] || [ "api" ]
Chef::Log.info( "SERVICES: %s" % services.inspect )

runit_service "cloudrim-api" do 
  if(services.include?( "api" ))
    action [ :enable, :start ]
  else
    action [ :disable, :down, :stop ]
  end
end

runit_service "cloudrim-kaiju" do
  log false
  if(services.include?( "kaiju" ))
    action [ :enable, :start ]
  else
    action [ :disable, :down, :stop ]
  end
end

runit_service "cloudrim-jaeger" do
  log false
  if(services.include?( "jaeger" ))
    action [ :enable, :start ]
  else
    action [ :disable, :down, :stop ]
  end
end

runit_service "cloudrim-scoreboard" do
  log false
  if(services.include?( "scoreboard" ))
    action [ :enable, :start ]
  else
    action [ :disable, :down, :stop ]
  end
end



