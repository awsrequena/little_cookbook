include 'test' 
include 'testresrc' 

Chef::Log.info("TEST SETUP IS RUNNING!") 

simple_test "A test" do 
  action :create 
end 

Chef::Log.info("TEST SETUP IS FINISHED RUNNING!") 

