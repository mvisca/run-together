module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      if env["warden"].nil?
        Rails.logger.error "[ActionCable] Warden not available in env"
        reject_unauthorized_connection
      elsif (verified_user = env["warden"].user)
        Rails.logger.info "[ActionCable] Connected: #{verified_user.email}"
        verified_user
      else
        Rails.logger.error "[ActionCable] No authenticated user found"
        reject_unauthorized_connection
      end
    end
  end
end
