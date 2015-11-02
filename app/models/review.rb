class Review < ActiveRecord::Base
	belongs_to :user
	belongs_to :artist
	default_scope -> { order('created_at DESC') }
	validates :content, presence: true
	validates :user_id, presence: true
	validates :album_id, presence: true

	def self.from_users_followed_by(user)
		followed_user_ids = "SELECT followed_id FROM relationships
							 WHERE follower_id = :user_id"
		where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
			   user_id: user)
	end

	def self.build(user, album, content)
    res = Review.new

    res.content = content
    res.type = album.type
		res.user_id = user.id
		res.album_id = album.id

    res.save!
  end

end
