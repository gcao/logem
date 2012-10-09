$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'logem'

logger = Logem::Logger.new 'SIMPLE'
logger.trace '1'
logger.debug '2'
logger.info  '3'
logger.warn  '4'
logger.error '5'

logger.log Logem::INFO, '33'

