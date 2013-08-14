

require 'chef/resource' 

class Chef 
  class Resource 
    class SimpleTest < Chef::Resource 
    
      def initialize(name, run_context=nil) 
        super 
        Chef::Log.info("SIMPLE RESOURCE IS INITIALIZING!") 
        @resource_name = :simple_test # Bind ourselves to the name with an underscore 
        @provider = Chef::Provider::SimpleTest # We need to tie to our provider 
        @action = :enable # Default Action Goes here 
        @allowed_actions = :create, :remove 
       end 
    end 
  end 
end 
    
class Chef 
  class Provider 
    class SimpleTest < Chef::Provider 
 
      # We MUST override this method in our custom provider 
      def load_current_resource 
        # Here we keep the existing version of the resource 
        # if none exists we create a new one from the resource we defined earlier 
        @current_resource ||= Chef::Resource::SimpleTest.new(new_resource.name) 
        @current_resource 
      end 
      
      def action_create 
        # Some ruby code 
        Chef::Log.info("SIMPLE IS CREATING!") 
      end 
      
      def action_remove 
        # More ruby code 
        Chef::Log.info("SIMPLE IS REMOVING!") 
      end 
   
    end 
  end 
end 
