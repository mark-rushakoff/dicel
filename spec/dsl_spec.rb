require 'spec_helper'

describe Dicel::DSL do
  subject { (Class.new { include Dicel::DSL }).new }
  %w(d1 d2 d10 d100 d123456789).each do |method|
    it { should respond_to(method) }
  end

  it { should_not respond_to('d5letters') }
end