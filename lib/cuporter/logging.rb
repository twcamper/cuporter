module Cuporter

  def self.log_error(exception_obj, *messages)
    ex = "\n\t#{exception_obj.class}: #{exception_obj.message}"
    ex += "\n\t#{exception_obj.backtrace.join("\n\t")}"
    Logging.error_logger.warn(messages.join(' ') + ex)
  end

  module Logging
    attr_accessor :output_home

    def error_logger
      @error_logger ||= begin
                         require "logger"
                         logger = ::Logger.new(error_log_file)
                         logger.level = ::Logger::WARN
                         logger.formatter = proc { |severity, datetime, progname, msg|
                           "#{severity} #{datetime.strftime('%b-%d-%y %H:%M:%S')} #{msg}\n\n"
                         }
                         logger
                       end
    end

    def error_log_file
      File.open(File.join(output_home, 'cuporter_errors.log'), 'a')
    end

    extend(Cuporter::Logging)

  end
end

