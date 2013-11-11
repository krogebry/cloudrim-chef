##
# A collection of build jobs for cloudrim.
# 

include Chef::DSL::IncludeRecipe

def action_jenkins_cloud_formation()
  git_url = new_resource.git_url
  az_name = new_resource.az_name
  region_name = new_resource.region_name
  domain_name = new_resource.domain_name
  deployment_name = new_resource.name

  opsauto_stack_builder "CloudFormation.%s.%s.%s" % [deployment_name, region_name, domain_name] do
    cmd "htc deployment create %s; htc deployment from file %s opsauto/dev/cloudrim-%s.json ; htc deployment launch %s" % [
      deployment_name, 
      deployment_name, 
      az_name, 
      deployment_name
    ]
    git_url git_url
    domain_name domain_name
    region_name region_name
  end
end



def action_jenkins_exec_helpers()
  region_name = new_resource.region_name
  domain_name = new_resource.domain_name
  deployment_name = new_resource.name

  proxy_url = "http://ops.prism.%s.int.%s:3128" % [region_name, domain_name]

  proxy = "HTTP_PROXY='%s' http_proxy='%s' HTTPS_PROXY='%s' https_proxy='%s'" % [proxy_url, proxy_url, proxy_url, proxy_url]

  job_name = "ExecHelper.chef-client.%s.%s.%s" % [deployment_name, region_name, domain_name]
  job_config = ::File.join(node[:jenkins][:server][:data_dir], "#{job_name}-config.xml")
  jenkins_job job_name do
    action :nothing
    config job_config
  end
  template job_config do
    owner "jenkins"
    group "jenkins"
    source "jenkins/chef_client.xml.erb"
    cookbook "opsauto"
    variables({
      #:cmd => "%s sudo chef-client -j /etc/chef/dna.json" % proxy, 
      :cmd => "sudo %s chef-client" % proxy, 
      :hostname => "ops.prism",
      :domain_name => domain_name,
      :region_name => region_name,
      :deployment_name => deployment_name
    })
    notifies :update, resources(:jenkins_job => job_name), :immediately
  end

  job_name = "ExecHelper.deploy-cloudrim.%s.%s.%s" % [deployment_name, region_name, domain_name]
  job_config = ::File.join(node[:jenkins][:server][:data_dir], "#{job_name}-config.xml")
  jenkins_job job_name do
    action :nothing
    config job_config
  end
  template job_config do
    owner "jenkins"
    group "jenkins"
    source "jenkins/deploy.xml.erb"
    variables({
      :cmd => "/home/ec2-user/deploy 0.0.8",
      :stacks => [ "clients" ],
      :hostname => "ops.prism",
      :domain_name => domain_name,
      :region_name => region_name,
      :deployment_name => deployment_name
    })
    notifies :update, resources(:jenkins_job => job_name), :immediately
  end

  job_name = "ExecHelper.redeploy.%s.%s.%s" % [deployment_name, region_name, domain_name]
  job_config = ::File.join(node[:jenkins][:server][:data_dir], "#{job_name}-config.xml")
  jenkins_job job_name do
    action :nothing
    config job_config
  end
  template job_config do
    owner "jenkins"
    group "jenkins"
    source "jenkins/rebalance.xml.erb"
    cookbook "cloudrim"
    variables({
      :stacks => [ "clients" ],
      :hostname => "ops.prism",
      :publish_to => "ExecHelper.chef-client.%s.%s.%s" % [deployment_name, region_name, domain_name],
      :domain_name => domain_name,
      :region_name => region_name,
      :deployment_name => deployment_name
    })
    notifies :update, resources(:jenkins_job => job_name), :immediately
  end

end
