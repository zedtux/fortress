module Fortress
  #
  # Object to easily use the Mechanism stored rules. It's a kind of helper
  # class
  #
  # @author zedtux
  #
  class ControllerInterface
    attr_accessor :instance, :params

    def initialize(controller_instance)
      self.instance = controller_instance
    end

    def params
      @params ||= Mechanism.authorisations[instance.class.name]
    end

    def blocked?
      params.nil?
    end

    def allow_all?
      params[:all] == true
    end

    def allow_all_without_except?
      allow_all? && params.key?(:except) == false
    end

    def allow_action?(name)
      return false if action_forbidden?(name.to_sym)

      if conditionnal_method_with_action?(name.to_sym)
        return params[:if][:method] == true
      end

      return true if action_allowed_from_only?(name.to_sym)

      allow_all?
    end

    def allow_method?
      params.key?(:if) && params[:if].key?(:method)
    end

    def needs_to_check_action?(name)
      params.key?(:if) && params[:if].key?(:actions) &&
        Array(params[:if][:actions]).include?(name)
    end

    def call_allow_method
      instance.send(params[:if][:method])
    end

    def conditionally_allowed?(action_name)
      return unless allow_method?
      return unless needs_to_check_action?(action_name)
      call_allow_method
    end

    def conditionnal_method_with_action?(name)
      return false unless params.key?(:if) && params[:if].key?(:actions)
      return true if params[:if][:actions].include?(name)
    end

    def action_forbidden?(name)
      Array(params[:except]).include?(name.to_sym)
    end

    def action_allowed_from_only?(name)
      Array(params[:only]).include?(name.to_sym)
    end
  end
end
