require 'yaml'
require File.dirname(__FILE__) + '/../../lib/dynect.rb'


describe Dynect, "when used to manage CNAME records" do
  
  before(:all) do
    @config = YAML.load_file("credentials.yml")  
  end
  
  before(:each) do
    @d = Dynect.new(@config["company"], @config["username"], @config["password"])
  end
  
  it "should be able to list records" do
    cname_domain = "cname"  
    results = @d.list_cname_records(cname_domain)
    results.class.should == Array
  end
  
  # it "should be able to add an CNAME record" do
  #   results = @d.add_cname_record(@config["cname_zone"], "demo002.cloudscale.net" )
  #   # puts results.inspect
  #   results.status.should == "success"
  # end
  
  # it "should be able to update an CNAME record" do
  #   results = @d.list_cname_records(@config["cname_zone"])
  #   results.status.should == "success"
  #   
  #   record = results.records.find {|x| x["rdata"]["cname"] == "test.domain.com"}
  #   
  #   if record
  #     update_result = @d.update_cname_record(record["record_id"], "rdata" => {"cname" => "test.domain.com"})
  #     update_result.status.should == "success"
  #   end
  # end
  
  # it "should be able to delete an CNAME record" do
  #   results = @d.list_cname_records(@config["cname_zone"])
  #   results.status.should == "success"
  #   
  #   record = results.records.find {|x| x["rdata"]["cname"] == "test.domain.com"}
  #   
  #   if record
  #     delete_result = @d.delete_a_record(record["record_id"])
  #     delete_result.status.should == "success"
  #   end
  # end
  
end