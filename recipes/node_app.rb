##
# NodeJS app

#export HTTP_PROXY='http://ops.prism.us-east-1.int.opsautohtc.net:3128'
#export http_proxy='http://ops.prism.us-east-1.int.opsautohtc.net:3128'
#export HTTPS_PROXY='http://ops.prism.us-east-1.int.opsautohtc.net:3128'
#export https_proxy='http://ops.prism.us-east-1.int.opsautohtc.net:3128'

package "nodejs"
package "nodejs-mongodb"
package "npm"


## npm install mongodb express
execute "npm mods" do
  command " HTTP_PROXY='http://ops.prism.us-east-1.int.opsautohtc.net:3128' http_proxy='http://ops.prism.us-east-1.int.opsautohtc.net:3128' HTTPS_PROXY='http://ops.prism.us-east-1.int.opsautohtc.net:3128' https_proxy='http://ops.prism.us-east-1.int.opsautohtc.net:3128' npm install mongodb express"
end
