module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :session_id

    def connect
      self.session_id = cookies[:visitor_id]
    end
  end
end