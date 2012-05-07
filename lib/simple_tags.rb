require "active_record"

require "simple_tags/tagging"
require "simple_tags/taggable"

if defined?(ActiveRecord::Base)
  class ActiveRecord::Base
    include SimpleTags::Taggable
  end
end
