require 'rubygems'
gem 'soap4r'

require 'soap/rpc/driver'

class Dynect
  # Provide the customer, user, and password information to intiate the SOAP connection.
  # If desired, an alternate driver can be supplied to enable mocking or the use of different protocols.
  def initialize(customer, user, password, driver = nil)
    @driver = driver || setup_driver
    @creds = {"cust" => customer, "user" => user, "pass" => password }
    
    add_methods
  end
  
  # Lists the zones associated with the accout. Specify a zone to get information on a specific one
  def list_zones(zone = nil)
    args = @creds
    args["zone"] = zone if zone
    
    response = @driver.ZoneGet args
    check_for_errors("when listing zone(s)", response)
    response.zones
  end
  
  # Create a new zone
  def create_zone(zone, type, options ={})
    args = @creds.merge("zone" => zone, "type" => type)
    args.merge!(options)
    
    response = @driver.ZoneAdd args
    check_for_errors("when creating a zone", response)
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
  def list_a_records(zone, options ={})
    args = @creds.merge("type" => "A", "zone" => zone)
    args.merge!(options)
    
    response = @driver.RecordGet args
    check_for_errors("when listing records", response)
    response.records
  end
  
  def add_a_record(zone, address, options = {})
    args = @creds.merge("type" => "A", "zone" => zone, "rdata" => {"address" => address})
    args.merge!(options)
    
    response = @driver.RecordAdd args
    check_for_errors("when adding an A record", response)
  end
  
  # Updates A records identified by the ID
  def update_a_record(id, options = {})
    args = @creds.merge("record_id" => id)
    args.merge!(options)
    
    response = @driver.RecordUpdate args
    check_for_errors("when updating an A record", response)
  end
  
  # Deletes an A record identified by the ID
  def delete_a_record(id)
    response = @driver.RecordDelete @creds.merge("record_id" => id)
    check_for_errors("when removing an A record", response)
  end
  
  # Lists the CNAME records associated with an account
  def list_cname_records(zone, options ={})
    args = @creds.merge("type" => "CNAME", "zone" => zone)
    args.merge!(options)
    
    response = @driver.RecordGet args
    check_for_errors("when listing CNAME records", response)
    response.records
  end
  
  # Adds a CNAME record for the specified zone
  def add_cname_record(zone, hostname, options = {} )
    args = @creds.merge("type" => "CNAME", "zone" => zone, "rdata" => {"cname" => hostname})
    args.merge!(options)
    
    response = @driver.RecordAdd args
    check_for_errors("when adding a CNAME record", response)
  end
  
  def update_cname_record(id, options = {})
    args = @creds.merge("id" => id)
    args.merge!(options)
    
    response = @driver.RecordUpdate args
    check_for_errors("when updating a CNAME record", response)
  end
  
  def delete_cname_record(id)
    response = @driver.RecordDelete @creds.merge("record_id" => id)
    check_for_errors("when removing a CNAME record", response)
  end  
  
  def update_soa(id, options = {})
    args = @creds.merge("record_id" => id)
    args.merge!(options)
    
    response = @driver.RecordUpdate args
    check_for_errors("when updating a SOA record", response)
  end
  
  def list_soa(zone, options = {})
    args = @creds.merge("type" => "SOA", "zone" => zone)
    args.merge!(options)
    
    response = @driver.RecordGet args
    check_for_errors("when listing SOA records", response)
    response.records.first
  end
  
  def list_nodes(zone, options = {})
    args = @creds.merge("zone" => zone)
    args.merge!(options)
    
    response = @driver.NodeGet args
    check_for_errors("when listing nodes", response)
  end
  
  def add_node(node, zone, options ={})
    args = @creds.merge("zone" => zone, "node" => "#{node}.#{zone}")
    args.merge!(options)
    
    response = @driver.NodeAdd args
    check_for_errors("when adding a node", response)
  end
  
  def delete_node(node, zone, options ={})
    args = @creds.merge("zone" => zone, "node" => "#{node}.#{zone}")
    args.merge!(options)
    
    response = @driver.NodeDelete args
    check_for_errors("when deleting a node", response)
  end
  
private

  def check_for_errors(message, response)
    if response["errors"]
      raise "#{message}, you got this error: #{response["errors"]["action"]}" unless response["errors"]["action"].nil?
    end
    response
  end
  
  def setup_driver
    SOAP::RPC::Driver.new('https://api.dynect.net/soap/', '/DynectAPI/')
  end
  
  def add_methods
    @driver.add_method("ZoneGet", "args")
    @driver.add_method("ZoneAdd", "args")
    @driver.add_method("RecordGet", "args")
    @driver.add_method("RecordAdd", "args")
    @driver.add_method("RecordUpdate", "args")
    @driver.add_method("RecordDelete", "args")
    @driver.add_method("NodeGet", "args")
    @driver.add_method("NodeAdd", "args")
    @driver.add_method("NodeDelete", "args")
  end
  
end
