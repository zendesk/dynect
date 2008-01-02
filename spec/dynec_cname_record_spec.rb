require File.dirname(__FILE__) + '/../lib/dynect.rb'
require File.dirname(__FILE__) + '/spec_helper'

describe Dynect, "when used to manage CNAME records" do

  before(:each) do
    @driver = mock("driver")
    @driver.should_receive(:add_method).at_least(:once)
      
    @d = Dynect.new("customer", "username", "password", @driver)
    
    @result = mock("test")
    @result.stub!(:errors).and_return(false)
    @result.stub!(:[])
  end

  it "should be able to list records" do
    @d.should respond_to(:list_cname_records)
  end
  
  it "should be able to accept additional parameters to filter the records you want" do
    @driver.should_receive(:RecordGet).and_return(@result)
    @d.list_cname_records("zone.domain.com")
  end
  
  it "should be able to add an CNAME record" do
    @d.should respond_to(:add_cname_record)
  end
  
  it "should require zone, hostname information when adding an CNAME record" do
    @driver.should_receive(:RecordAdd).and_return(@result)   
    @d.add_cname_record("test.domain.com", "cname.domain.com" )
  end
  
  it "should be able to accept additional parameters when creating an CNAME record" do
    @driver.should_receive(:RecordAdd).and_return(@result)    
    @d.add_cname_record("test.domain.com", "cname.domain.com")
  end
  
  it "should be able to update CNAME records" do
    @d.should respond_to(:update_cname_record)
  end
   
  it "should require the CNAME record id to update" do
    @driver.should_receive(:RecordUpdate).and_return(@result)
    @d.update_cname_record("id")    
  end
  
  it "should be able to accept additional parameters when updating an CNAME record" do
    @driver.should_receive(:RecordUpdate).and_return(@result)
    @d.update_cname_record("id", "address" => "192.168.1.1")    
  end
  
  it "should be able to delete CNAME records" do
    @d.should respond_to(:delete_cname_record)
  end
    
  it "should require the CNAME record id to delete" do
    @driver.should_receive(:RecordDelete).and_return(@result)
    @d.delete_cname_record("id")
  end 
  

end