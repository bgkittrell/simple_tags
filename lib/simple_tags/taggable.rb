  module SimpleTags #:nodoc:
    module Taggable #:nodoc:
      extend ActiveSupport::Concern

      def tag_with(list)
        Tagging.transaction do
          self.taggings.destroy_all

          Tagging.parse(list).each do |name|
            tagging = Tagging.new
            taggable = self
            tagging.scope_id = taggable.send(self.simple_tags_options[:scope].to_s + "_id") if self.simple_tags_options[:scope]
            tagging.tag = name
            self.taggings << tagging
          end
        end
      end
      
      def tag_string=(list)
        @tag_string = list
      end

      def tag_string
        taggings.map{|tg| tg.tag }.join(", ")
      end

      def tags
        taggings.map{|tg| tg.tag }
      end
      
      def save_tags
        tag_with(@tag_string) unless @tag_string.nil?
        @tag_string = nil
      end

      module ClassMethods
        def simple_tags(options = {})
          class_attribute :simple_tags_options

          self.simple_tags_options = {
            :taggable_type => self.base_class.name,
            :scope => options[:scope]
          }
          
          has_many :taggings, :as => :taggable, :dependent => :destroy
          
          after_save :save_tags
        end

        def find_tagged_with(list)
          find_by_sql([
            "SELECT #{table_name}.* FROM #{table_name}, taggings " +
            "WHERE #{table_name}.#{primary_key} = taggings.taggable_id " +
            "AND taggings.taggable_type = ? " +
            "AND taggings.tag IN (?)",
            simple_tags_options[:taggable_type], list
          ])
        end
      end
    end
  end

