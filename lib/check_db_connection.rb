module CheckDbConnection
  def self.connected?
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection
    ActiveRecord::Base.connected?
  rescue
    false # Check must return boolean, not an exception.
  end
end
