require 'active_support/core_ext/module/attribute_accessors'

module Fortress
  #
  # Mechanism embbed all the logic of the Fortress library.
  #
  # @author zedtux
  #
  module Mechanism
    # Authorisations stores the authorisations per controllers.
    #
    # This is a big picture of the structured data:
    # {
    #   "UsersController": {
    #     "all": true
    #   },
    #   "LogsController": {
    #     "all": true,
    #     "except": [
    #       "destroy"
    #     ]
    #   },
    #   "NotificationsController": {
    #     "only": [
    #       "new",
    #       "create",
    #       "edit",
    #       "update"
    #     ]
    #   }
    #   "PostsController": {
    #     "only": [
    #       "edit",
    #       "update"
    #     ]
    #     "if": {
    #       "method": :can_create_post?,
    #       "actions": [
    #         "new",
    #         "create"
    #       ]
    #     }
    #   },
    #   "CommentsController": {
    #     "if": {
    #       "method": :is_admin?,
    #       "actions": :destroy
    #     }
    #   }
    # }
    mattr_accessor :authorisations

    def self.initialize_authorisations
      self.authorisations = {}
    end

    def self.parse_options(controller, actions, options)
      options.each do |key, value|
        case key
        when :if
          Mechanism.authorise_if_truthy(controller.name, value, actions)
        when :except
          Mechanism.authorise_excepted(controller.name, value)
        end
      end
    end

    def self.append_or_update(controller_name, key, value)
      authorisations[controller_name] ||= {}
      if authorisations[controller_name].key?(key)
        if authorisations[controller_name][key].is_a?(Hash)
          authorisations[controller_name][key].merge!(value)
        else
          authorisations[controller_name][key] = value
        end
      else
        authorisations[controller_name].merge!(key => value)
      end
    end

    def self.authorise!(class_name, actions)
      if actions == :all
        append_or_update(class_name, :all, true)
        return
      end
      append_or_update(class_name, :only, Array(actions))
    end

    private

    def self.authorise_if_truthy(class_name, method_sym, actions)
      append_or_update(class_name, :if, method: method_sym,
                                        actions: Array(actions))
    end

    def self.authorise_excepted(class_name, action)
      append_or_update(class_name, :except, Array(action))
    end

    def self.authorised?(controller, action_name)
      return false if controller.blocked?

      # When the complete controller is authorised
      return true if controller.allow_all_without_except?

      # When the controller allows some actions and the current action is
      # allowed
      return true if controller.allow_action?(action_name)

      # When the controller implement the authorisation method
      if controller.allow_method?
        if controller.needs_to_check_action?(action_name)
          allowed = controller.call_allow_method
          return true if allowed
        end
      end

      false
    end
  end
end
