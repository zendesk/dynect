require 'yaml'
require File.dirname(__FILE__) + '/../../lib/dynect.rb'


describe Dynect, "when used to manage A records" do
  
  before(:all) do
    @config = YAML.load_file("credentials.yml")  
  end
  
  before(:each) do
    @d = Dynect.new(@config["company"], @config["username"], @config["password"])
  end
  
  it "should be able to list records" do
    results = @d.list_a_records("zone" => @config["zone"])
    results.status.should == "success"
  end
  
  it "should be able to add an A record" do
    results = @d.add_a_record(@config["zone"], "10.0.0.1" )
    results.status.should == "success"
  end
  
  it "should be able to update an A record" do
    results = @d.list_a_records("zone" => @config["zone"])
    results.status.should == "success"
    
    record = results.records.find {|x| x["rdata"]["address"] == "10.0.0.1"}
    
    if record
      update_result = @d.update_a_record(record["record_id"], "rdata" => {"address" => "10.0.0.1"})
      update_result.status.should == "success"
    end
  end
  
  it "should be able to delete an A record" do
    results = @d.list_a_records("zone" => @config["zone"])
    results.status.should == "success"
    
    record = results.records.find {|x| x["rdata"]["address"] == "10.0.0.1"}
    
    if record
      delete_result = @d.delete_a_record(record["record_id"])
      delete_result.status.should == "success"
    end
  end
  

  
end