require File.dirname(__FILE__) + '/../lib/dynect.rb'
require File.dirname(__FILE__) + '/spec_helper'


describe Dynect, "when used to manage SOA" do
  
  before(:each) do
    @driver = mock("driver")
    @driver.should_receive(:add_method).at_least(:once)
      
    @d = Dynect.new("customer", "username", "password", @driver)
    
    @result = mock("test")
    @result.stub!(:errors).and_return(false)
    @result.stub!(:[])
  end
  
  it "should be able to update SOA elements" do
    @d.should respond_to(:update_soa)
  end
  
  it "should accept options to update" do
    @driver.should_receive(:RecordUpdate).and_return(@result)
    @d.update_soa("rname" => "root.domain.com")
  end
  
  it "should list SOA elements" do
    @driver.should_receive(:RecordGet).and_return(@result)
    @result.stub!(:records).and_return([])
    @d.list_soa("foo.domain.com")
  end  
end