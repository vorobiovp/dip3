class Post < ApplicationRecord
    acts_as_votable
    validates :title, :content, presence: true
    has_rich_text :content
    belongs_to :user

    def replies
      Comment.where("post_id = ? and parent_id == 0", self.id).order(["parent_id", "id"]).group_by { |comment| comment["parent_id"] }
    end

    def comments
      Comment.where("post_id = ? and parent_id != 0").order("id")
    end
  end