module DatabaseCleaner
  module CouchRestModel
    def self.available_strategies
      %w[truncation]
    end
  end
end
