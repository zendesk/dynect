require File.dirname(__FILE__) + '/../lib/dynect.rb'
require File.dirname(__FILE__) + '/spec_helper'


describe Dynect, "when used to manage zones" do
  
  before(:each) do
    @driver = mock("driver")
      
    @d = Dynect.new("customer", "username", "password", @driver)
    
    @result = mock("test")
    @result.stub!(:errors).and_return(false)
    @result.stub!(:[])
  end
  
  it "should have a list zones method" do
    @d.should respond_to(:list_zones)
  end
  
  it "should be able to retireve info about a specific zone" do
    @driver.should_receive(:ZoneGet).and_return(@result)
    @result.stub!(:zones)
    @d.list_zones("test.domain.com")
  end
  
  it "should call the driver when list zones is called" do
    expected_creds = {"cust" => "customer", "user" => "username", "pass" => "password"}
    @driver.should_receive(:ZoneGet).with(expected_creds).and_return(@result)
    @result.stub!(:zones)
    @d.list_zones
  end
  
  it "should have a create zone method" do
    @d.should respond_to(:create_zone)
  end
      
  it "should require a zone name and type when creating a zone" do
    @driver.should_receive(:ZoneAdd).and_return(@result)
    @d.create_zone("test.domain.com", "primary")
  end
  
  it "should be able to accept additional parameters when creating a zone"  do
    @result.stub!(:call)
    @driver.should_receive(:ZoneAdd).and_return(@result)
    
    options = {"ttl" => "24", "data" => {"rname" => "test@example.com", "master" => "192.168.1.1"}}
    
    @d.create_zone("test.domain.com", "primary", options).should_not raise_error    
  end
  
end
