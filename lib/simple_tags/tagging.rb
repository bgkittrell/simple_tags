class Tagging < ActiveRecord::Base
  belongs_to :taggable, :polymorphic => true

  def self.all_tags
    Tagging.select("tag").uniq.all.map { |t| t.tag }
  end

  def self.parse(list)
    tag_names = []

    # then, get whatever's left
    tag_names.concat list.split(/,/)

    # strip whitespace from the names
    tag_names = tag_names.map { |t| t.strip }

    # delete any blank tag names
    tag_names = tag_names.delete_if { |t| t.empty? }
    
    return tag_names
  end

  def self.tagged_class(taggable)
    taggable.base_class.name
  end
  
  def self.find_taggable(tagged_class, tagged_id)
    tagged_class.constantize.find(tagged_id)
  end

  def to_s
    self.tag
  end
end
