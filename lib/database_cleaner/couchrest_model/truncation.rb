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
        models.each { |model| model.database.bulk_delete(document_bundle(model)) }
      end

      private

      def document_bundle(model)
        model.all.map { |doc| { _id: doc['_id'], _rev: doc['_rev'], _deleted: true } }
      end

      def models
        ::CouchRest::Model::Base.subclasses
      end
    end
  end
end
