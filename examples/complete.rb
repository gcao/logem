$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'logem'

class MyOutputter
  attr :contents

  def initialize
    @contents = []
  end

  def puts content
    @contents << content
  end
end

outputter = MyOutputter.new

ENV["COMPLETE_LOG_LEVEL"] = "debug"

logger = Logem::Logger.new 'SIMPLE', :log_level_env => 'COMPLETE_LOG_LEVEL', :output => outputter
logger.trace '1'
logger.debug '2'
logger.info  '3'
logger.warn  '4'
logger.error '5'

puts outputter.contents.map {|content| "MyOutputter > #{content}"}
