require 'spec_helper'

describe Activerecord::Commentator do
  let(:stringio) { StringIO.new }
  let(:logger) { Logger.new(stringio) }

  before do
    ActiveRecord::Base.logger = logger
    Activerecord::Commentator::Configuration.paths = [
      /_spec\.rb/
    ]
    ActiveRecord::Base.connection.extend(Activerecord::Commentator)
  end

  describe "#execute" do
    before do
      ActiveRecord::Base.connection.execute("select 1")
    end
    it "includes execute location in log" do
      output = stringio.tap(&:rewind).read
      expect(output).to match(/#{__FILE__}:[0-9]+/)
    end
  end
end
