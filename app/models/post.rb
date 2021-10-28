class Post < ApplicationRecord
    acts_as_votable
    validates :title, :content, presence: true
    has_rich_text :content
    belongs_to :user
  end