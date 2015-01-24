module Fortress
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new

    yield(configuration)

    apply_configuration!
  end

  class Configuration
    attr_reader :options

    def externals=(value)
      return unless value

      @options = { externals: externals_from(value) }
    end

    private

    def externals_from(value)
      case
      when value.is_a?(String) then [value]
      when value.is_a?(Array) then value
      end
    end
  end

  private

  def self.apply_configuration!
    if configuration.options.try(:key?, :externals)
      fortress_allow_externals!(configuration.options[:externals])
    end
  end

  def self.fortress_allow_externals!(externals)
    externals.each { |name| Mechanism.authorise!(name, :all) }
  end
end
