module CertifyNotifications
  # notification preference class that handles getting and send new notification preferences
  class NotificationPreference < Resource
    # get the notification preferences for a user
    # rubocop:disable Metrics/AbcSize
    def self.where(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = notification_preference_safe_params params
      return CertifyNotifications.unprocessable if safe_params.empty?
      response = connection.request(method: :get,
                                    path: build_notification_preference_path(safe_params))
      return_response(json(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end
    singleton_class.send(:alias_method, :find, :where)

    # update notification preferences
    def self.update(params = nil)
      return CertifyNotifications.bad_request if empty_params(params)
      safe_params = notification_preference_safe_params params
      return CertifyNotifications.unprocessable if safe_params.empty?
      response = connection.request(method: :put,
                                    path: build_notification_preference_path(safe_params),
                                    body: safe_params.to_json,
                                    headers:  { "Content-Type" => "application/json" })
      return_response(check_empty_body(response.data[:body]), response.data[:status])
    rescue Excon::Error => error
      handle_excon_error(error)
    end

    private_class_method

    def self.check_empty_body(body)
      body.empty? ? { message: 'No Content' } : json(body)
    end

    # helper for white listing parameters
    def self.notification_preference_safe_params(params)
      permitted_keys = %w[subscribe_high_priority_emails subscribe_low_priority_emails]
      permitted_keys.push(*version_specific_keys)
      params.select { |key, _| permitted_keys.include? key.to_s }
    end

    def self.version_specific_keys
      case notify_api_version
      when 1
        %w[id user_id]
      when 2
        %w[uuid user_uuid]
      when 3
        %w[uuid user_uuid]
      end
    end

    def self.build_notification_preference_path(params)
      "#{path_prefix}/#{notification_preferences_path}/#{user_param_value(params)}"
    end

    def self.build_create_notification_preferences_path
      "#{path_prefix}/#{notification_preferences_path}"
    end

    # Returns user ID or UUID value based on version
    def self.user_param_value(params)
      case notify_api_version
      when 1
        params[:user_id]
      when 2
        params[:user_uuid]
      when 3
        params[:user_uuid]
      end
    end
  end
end
