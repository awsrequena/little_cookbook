execute "Write text file /etc/little_cookbook" do
  command "echo #{node[:little][:thing]} > /etc/little_cookbook"
end

cookbook_file "/tmp/guagua.txt" do
  source "guagua.txt"
  mode 0755
  owner "root"
  group "root"
end
