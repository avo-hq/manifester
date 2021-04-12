class Manifester::Env
  DEFAULT = "production".freeze

  delegate :config_path, :logger, to: :@manifester

  def self.inquire(manifester)
    new(manifester).inquire
  end

  def initialize(manifester)
    @manifester = manifester
  end

  def inquire
    fallback_env_warning if config_path.exist? && !current
    current || DEFAULT.inquiry
  end

  private
    def current
      Rails.env.presence_in(available_environments)
    end

    def fallback_env_warning
      logger.info "RAILS_ENV=#{Rails.env} environment is not defined in config/manifester.yml, falling back to #{DEFAULT} environment"
    end

    def available_environments
      if config_path.exist?
        YAML.load(config_path.read).keys
      else
        [].freeze
      end
    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{config_path}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{e.message}"
    end
end
