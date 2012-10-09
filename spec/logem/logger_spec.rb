require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe "Logem::Logger" do
  it "#initialize" do
    logger = Logem::Logger.new 'TEST'
    logger.context.should eql 'TEST'
  end
end

