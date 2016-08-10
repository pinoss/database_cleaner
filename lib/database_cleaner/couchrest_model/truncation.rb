require 'database_cleaner/generic/truncation'

module DatabaseCleaner
  module CouchRestModel
    class Truncation
      include ::DatabaseCleaner::Generic::Truncation

      def initialize(options = {})
        if options.has_key?(:only) || options.has_key?(:except)
          raise ArgumentError, "The :only and :except options are not available for use with CouchRestModel/CouchDB."
        elsif !options.empty?
          raise ArgumentError, "Unsupported option. You specified #{options.keys.join(',')}."
        end
        super
      end

      def clean
        models.each do |model|
          doc_ids = model.all.rows.map { |doc| doc['id'] }
          model.database.bulk_delete(doc_ids)
        end
      end

      private

      def models
        ::CouchRest::Model::Base.subclasses
      end
    end
  end
end
