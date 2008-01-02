require File.dirname(__FILE__) + '/../lib/dynect.rb'
require File.dirname(__FILE__) + '/spec_helper'

describe Dynect, "when used to manage A records" do

  before(:each) do
    @driver = mock("driver")
    @driver.should_receive(:add_method).at_least(:once)
      
    @d = Dynect.new("customer", "username", "password", @driver)
    
    @result = mock("test")
    @result.stub!(:errors).and_return(false)
    @result.stub!(:[])
  end

  it "should be able to list records" do
    @d.should respond_to(:list_a_records)
  end
  
  it "should be able to accept additional parameters to filter the records you want" do
    @driver.should_receive(:RecordGet).and_return(@result)
    @d.list_a_records("myzone.domain.com")
  end
  
  it "should be able to add an A record" do
    @d.should respond_to(:add_a_record)
  end
  
  it "should require zone, address information when adding an A record" do
    @driver.should_receive(:RecordAdd).and_return(@result)   
    @d.add_a_record("test.domain.com", "192.168.1.1" )
  end
  
  it "should be able to accept additional parameters when creating an A record" do
    @driver.should_receive(:RecordAdd).and_return(@result)    
    @d.add_a_record("test.domain.com", "192.168.1.1", "ttl" => "64")
  end
  
  it "should be able to update A records" do
    @d.should respond_to(:update_a_record)
  end
   
  it "should require the A record id to update" do
    @driver.should_receive(:RecordUpdate).and_return(@result)
    @d.update_a_record("id")    
  end
  
  it "should be able to accept additional parameters when updating an A record" do
    @driver.should_receive(:RecordUpdate).and_return(@result)
    @d.update_a_record("id", "address" => "192.168.1.1")    
  end
  
  it "should be able to delete A records" do
    @d.should respond_to(:delete_a_record)
  end
    
  it "should require the A record id to delete" do
    @driver.should_receive(:RecordDelete).and_return(@result)
    @d.delete_a_record("id")
  end

end