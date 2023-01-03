module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :visitor_id

    def connect
      self.visitor_id = cookies[:visitor_id]
    end
  end
end