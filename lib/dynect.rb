require 'rubygems'
gem 'soap4r'

require 'soap/rpc/driver'

class Dynect
  
  def initialize(customer, user, password, driver = setup_driver)
    @driver = driver
    @creds = {"cust" => customer, "user" => user, "pass" => password }
    
    add_methods
  end
  
  def list_zones(zone = "")
    args = @creds.merge("zone" => zone) unless zone.empty?
    
    response = @driver.ZoneGet args
    check_for_errors("when listing zone(s)", response)
  end
  
  def create_zone(zone, type, options ={})
    args = @creds.merge("zone" => zone, "type" => type)
    args.merge!(options)
    
    response = @driver.ZoneAdd args
    
    check_for_errors("when creating a zone", response)
  end
  
  def list_records(options ={})
    args = @creds.merge(options)
    
    response = @driver.RecordGet options
    check_for_errors("when listing records", response)
  end
  
  def add_a_record(zone, address, options = {})
    args = @creds.merge("type" => "A", "zone" => zone, "rdata" => {"address" => address})
    args.merge!(options)
    
    response = @driver.RecordAdd options
    check_for_errors("when adding an A record", response)
  end
  
  # Updates A records identified by the ID
  def update_a_record(id, options = {})
    args = @creds.merge("record_id" => id)
    args.merge!(options)
    
    response = @driver.RecordUpdate args
    check_for_errors("when updating an A record", response)
  end

  def delete_a_record(id)
    response = @driver.RecordDelete @creds.merge("record_id" => id)
    check_for_errors("when removing an A record", response)
  end
  
private
  def check_for_errors(message, response)
    if response.errors
      raise "#{message}, you got this error: #{response.errors.action}" unless response.errors.action.nil?
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
  end
  
end
