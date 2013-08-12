execute "Write text file /etc/little_cookbook" do
  command "echo #{node[:little][:thing]} > /etc/little_cookbook"
end
