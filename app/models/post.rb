class Post < ApplicationRecord
    acts_as_votable
    validates :content, presence: true
    validates :title, presence: true
    has_rich_text :content
    belongs_to :user
    has_many :taggings, dependent: :delete_all
    has_many :tags, through: :taggings, dependent: :delete_all
    has_many :comments, dependent: :delete_all


    def tag_list
      self.tags.collect do |tag|
        tag.name
      end.join(", ")
    end
    
    def tag_list=(tags_string)
      tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
      new_or_found_tags = tag_names.collect { |name| Tag.find_or_create_by(name: name) }
      self.tags = new_or_found_tags
    end
  end