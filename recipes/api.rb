##
# API servce
#
services = node["htc"]["services"] || [ "api" ]
Chef::Log.info( "SERVICES: %s" % services.inspect )

num_procs = `cat /proc/cpuinfo |grep processor|wc -l`.to_i + 1
Chef::Log.info( "NumProcs: %i" % num_procs )

num_procs.times do |pid|
  Chef::Log.info( "PID: %i" % (9000+pid) )
  runit_service "cloudrim-api%i" % pid do 
    action [ :enable, :start ]
    options({ :port => (9000+pid) })
    template_name "cloudrim-api"
    log_template_name "cloudrim-api"
  end
end

["kaiju", "jaeger", "scoreboard"].each do |sv_name|
  runit_service "cloudrim-%s" % sv_name do
    log false
    if(services.include?( sv_name ))
      action [ :enable, :start ]
    else
      action [ :disable, :down, :stop ]
    end
  end
end

cookbook_file "/home/ec2-user/restart_all" do
  mode "0755"
  user "ec2-user"
  group "ec2-user"
  source "restart_all"
end
