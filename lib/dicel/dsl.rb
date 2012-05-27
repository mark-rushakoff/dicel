module Dicel
  module DSL
    def respond_to_missing?(method, include_private)
      method =~ /^d(\d+)$/ || super
    end
  end
end