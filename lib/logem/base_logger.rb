module Logem
  class BaseLogger
    # Log levels
    ERROR = 50
    WARN  = 40
    INFO  = 30
    DEBUG = 20
    TRACE = 10

    DEFAULT_LEVEL = INFO
    DEFAULT_LOG_LEVEL_ENV = "LOGEM_LOG_LEVEL"

    attr :log_level_env
    attr :context
    attr_accessor :level

    def initialize context, options = {}
      @context        = context
      @log_level_env  = options[:log_level_env ] || DEFAULT_LOG_LEVEL_ENV
      @level          = options[:level         ] || self.class.string_to_level(ENV[@log_level_env]) || DEFAULT_LEVEL
      @output         = options[:output        ] || $stdout
      @time_formatter = options[:time_formatter]
      @output_supports_logem = @output.respond_to? :logem
    end

    def log level, *args
      return if @level > level

      _log_ level, *args
    end

    def visible? level
      @level <= level
    end

    def self.level_to_string level
      case level
      when ERROR then "ERROR"
      when WARN  then "WARN "
      when INFO  then "INFO "
      when DEBUG then "DEBUG"
      when TRACE then "TRACE"
      else level.to_s
      end
    end

    def self.string_to_level level_string
      return DEFAULT_LEVEL if level_string.nil? or level_string.strip == ''

      case level_string.strip.downcase
      when 'error' then ERROR
      when 'warn'  then WARN
      when 'info'  then INFO
      when 'debug' then DEBUG
      when 'trace' then TRACE
      else
        $stdout.puts "Logem warning: #{level_string} is not a valid log level, " +
                     "default to #{level_to_string(DEFAULT_LEVEL).strip}"
        DEFAULT_LEVEL
      end
    end

    %w[error warn info debug trace].each do |level_str|
      level = string_to_level(level_str)
      
      define_method level_str do |*args|
        return if @level > level

        _log_ level, *args
      end
    end

    private

    def _log_ level, *args
      time = Time.now

      if @output_supports_logem
        @output.logem time, level, @context, *args
      else
        time_str = @time_formatter ? @time_formatter.call(time) : time.to_s

        parts = [time_str, self.class.level_to_string(level), @context.to_s]
        args.each {|arg| parts << (arg.nil? ? 'nil' : arg.to_s) }

        @output.puts parts.join(' | ')
      end
    end
  end
end

