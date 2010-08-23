require 'rubygems'
gem 'soap4r'

require 'soap/rpc/driver'

class Dynect
  # Provide the customer, user, and password information to intiate the SOAP connection.
  # If desired, an alternate driver can be supplied to enable mocking or the use of different protocols.
  def initialize(customer, user, password, driver = setup_driver)
    @driver = driver
    @creds = { "cust" => customer, "user" => user, "pass" => password }
  end
  
  # Lists the zones associated with the accout. Specify a zone to get information on a specific one
  def list_zones(zone = nil)
    args = @creds
    args["zone"] = zone if zone
    
    response = @driver.ZoneGet args
    check_for_errors("when listing zone(s) #{zone}", response)
    response.zones
  end
  
  # Create a new zone
  def create_zone(zone, type, options ={})
    args = @creds.merge("zone" => zone, "type" => type)
    args.merge!(options)
    
    response = @driver.ZoneAdd args
    check_for_errors("when creating zone #{zone} of type #{type}", response)
  end
  
  # Lists all the A records associated with the account.
  #
  # == Options 
  # * +node+ -- The fully qualified domain name of the node to retreive records from. Omit or enter an empty string to get the records of the root node
  # * +record_id+ -- The ID of the record to retreive information of
  #
  # == Useage
  #
  #   d = Dynect.new("customer", "username", "password")
  #   d.list_a_records("myzone.domain.com")
  #
  def list_a_records(zone, options = {})
    args = @creds.merge("type" => "A", "zone" => zone)
    args.merge!(options)
    
    response = @driver.RecordGet args
    check_for_errors("when listing records for #{zone}", response)
    response.records
  end
  
  def add_a_record(zone, address, options = {})
    args = @creds.merge("type" => "A", "zone" => zone, "rdata" => {"address" => address})
    args.merge!(options)
    
    response = @driver.RecordAdd args
    check_for_errors("when adding an A record for zone #{zone} and address #{address}", response)
  end
  
  # Updates A records identified by the ID
  def update_a_record(id, options = {})
    args = @creds.merge("record_id" => id)
    args.merge!(options)
    
    response = @driver.RecordUpdate args
    check_for_errors("when updating an A record for record id #{id}", response)
  end
  
  # Deletes an A record identified by the ID
  def delete_a_record(id)
    response = @driver.RecordDelete @creds.merge("record_id" => id)
    check_for_errors("when removing an A record for record id #{id}", response)
  end
  
  # Lists the CNAME records associated with an account
  def list_cname_records(zone, options = {})
    args = @creds.merge("type" => "CNAME", "zone" => zone)
    args.merge!(options)
    
    response = @driver.RecordGet args
    check_for_errors("when listing CNAME records for zone #{zone}", response)
    response.records
  end
  
  # Adds a CNAME record for the specified zone
  def add_cname_record(zone, hostname, options = {})
    args = @creds.merge("type" => "CNAME", "zone" => zone, "rdata" => {"cname" => hostname})
    args.merge!(options)
    
    response = @driver.RecordAdd args
    check_for_errors("when adding a CNAME record for zone #{zone} and hostname #{hostname}", response)
  end
  
  def update_cname_record(id, options = {})
    args = @creds.merge("id" => id)
    args.merge!(options)
    
    response = @driver.RecordUpdate args
    check_for_errors("when updating a CNAME record for record id #{id}", response)
  end
  
  def delete_cname_record(id)
    response = @driver.RecordDelete @creds.merge("record_id" => id)
    check_for_errors("when removing a CNAME record for record id #{id}", response)
  end  
  
  def update_soa(id, options = {})
    args = @creds.merge("record_id" => id)
    args.merge!(options)
    
    response = @driver.RecordUpdate args
    check_for_errors("when updating a SOA record for record id #{id}", response)
  end
  
  def list_soa(zone, options = {})
    args = @creds.merge("type" => "SOA", "zone" => zone)
    args.merge!(options)
    
    response = @driver.RecordGet args
    check_for_errors("when listing SOA records for zone #{zone}", response)
    response.records.first
  end
  
  def list_nodes(zone, options = {})
    args = @creds.merge("zone" => zone)
    args.merge!(options)
    
    response = @driver.NodeGet args
    check_for_errors("when listing nodes for zone #{zone}", response)
  end
  
  def add_node(node, zone, options = {})
    args = @creds.merge("zone" => zone, "node" => "#{node}.#{zone}")
    args.merge!(options)
    
    response = @driver.NodeAdd args
    check_for_errors("when adding node #{node} to zone #{zone}", response)
  end
  
  def delete_node(node, zone, options ={})
    args = @creds.merge("zone" => zone, "node" => "#{node}.#{zone}")
    args.merge!(options)
    
    response = @driver.NodeDelete args
    check_for_errors("when deleting node #{node} from zone #{zone}", response)
  end
  
private

  def check_for_errors(message, response)
    if response["errors"]
      raise "#{message}, you got this error: #{response["errors"].inspect}"
    end
    if response["status"] == "failure"
      raise "#{message}, you got this failure: #{response["messages"].inspect}"
    end
    response
  end
  
  def setup_driver
    driver = SOAP::RPC::Driver.new('https://api.dynect.net/soap/', '/DynectAPI/')
    driver.mapping_registry = SOAP::Mapping::EncodedRegistry.new(:allow_original_mapping => true)

    ["ZoneGet", "ZoneAdd", "RecordGet", "RecordAdd", "RecordUpdate", "RecordDelete", "NodeGet", "NodeAdd", "NodeDelete"].each do |soap_action|
      driver.add_method(soap_action, "args")
    end
    driver
  end  
end
