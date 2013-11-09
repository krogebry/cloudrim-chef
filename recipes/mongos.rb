##
# MongoDB client

cookbook_file "/etc/sysconfig/mongos" do
  action :delete
end

#execute "stop mongd" do
  #command "service mongod stop"
#end

service "mongod" do
  action [:disable, :stop]
end
