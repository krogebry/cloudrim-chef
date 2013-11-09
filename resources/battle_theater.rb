##
# CloudRim bits.
include Chef::DSL::Recipe

actions :jenkins_cloud_formation, :jenkins_exec_helpers

attribute :git_url, :kind_of => String, :default => "git@gitlab.dev.sea1.csh.tc:"
attribute :az_name, :kind_of => String
attribute :domain_name, :kind_of => String
attribute :region_name, :kind_of => String
attribute :deployment_name, :kind_of => String

def initialize(name, run_context = nil)
  super
  @action = :deploy
end


