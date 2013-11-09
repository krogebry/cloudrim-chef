##
# A collection of build jobs for an opsauto deployment.
# 
# The idea here is to create the build jobs that we can use later on.  Eventually we'll use this
#   as our platform for consistant, reliable deployments of both software and chef bits.
#
# AUTOMATE ALL THE THINGS!!

link "/usr/bin/htc" do
  to "/opt/rbenv/versions/2.0.0-p0/bin/htc"
end

pipelines = []
dashboards = []



gem_package "htmlentities" do
  action :install
end
execute "install htmlentities" do
  command "gem install htmlentities"
end
require "htmlentities"


region_name = "us-east-1"
domain_name = "opsautohtc.net"
pipelines.push({
  :name => "Launch us-east-1",
  :num_builds => 3,
  :description => "<h1>Prism</h1><ul><li>Cloud: AWS</li><li>Region: us-east-1</li><li>Account: HTC CS DEV</li><li>Owner: Bryan Kroger ( bryan_kroger@htc.com )</li></ul>",
  :refresh_freq => 3,
  :first_job_name => "CloudFormation.prism-vpc.us-east-1.opsautohtc.net",
  :build_view_title => "Launch us-east-1"
})
cloudrim_battle_theater "Tanaki" do
  action :jenkins_cloud_formation
  az_name "us-east-1b"
  git_url "git@gitlab.dev.sea1.csh.tc:operations/deployments.git"
  region_name region_name
  domain_name domain_name
end
cloudrim_battle_theater "Tanaki" do
  action :jenkins_exec_helpers
  az_name "us-east-1b"
  git_url "git@gitlab.dev.sea1.csh.tc:operations/deployments.git"
  region_name region_name
  domain_name domain_name
end
dashboards.push({ :name => "us-east-1", :region_name => "us-east-1" })



template "/var/lib/jenkins/jenkins-data/config.xml" do
  owner "jenkins"
  group "jenkins"
  source "jenkins/config.xml.erb"
  #notifies :reload, "service[jenkins]"
  variables({ :pipelines => pipelines, :dashboards => dashboards })
end
