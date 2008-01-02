require 'yaml'
require File.dirname(__FILE__) + '/../../lib/dynect.rb'


describe Dynect, "when used to manage SOA records" do
  
  before(:all) do
    @config = YAML.load_file("credentials.yml")  
  end
  
  before(:each) do
    @d = Dynect.new(@config["company"], @config["username"], @config["password"], @driver)
  end
  
  it "should be able to update" do
    soa = @d.list_soa(@config["zone"])
    
    results = @d.update_soa(soa["record_id"], "soa" => {"rname" => "support@neotactics.com."})
    results.status.should == "success"
  end
  
end