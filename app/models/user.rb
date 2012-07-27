#encoding: utf-8

class User < ActiveRecord::Base
	validates :name, {:presence => true, :uniqueness => true}
	has_many :followings, :foreign_key => :owner_id, :class_name => "Follow"
	before_destroy :remove_followings
	
	def followed_by
		# We get all the following which point to self
		Follow.where(:user_id => self.id).collect { |f| f.owner }
	end
	
	def unfollowings
		ids = [self.id] + self.followings.collect {|f| f.user_id } # These are all the user it is following
		User.order("name ASC").all.select {|u| !ids.include?(u.id) }
	end
	
	private
		def remove_followings
			# Remove any associated relation
			Follow.where(:user_id => self.id).delete_all
			Follow.where(:owner_id => self.id).delete_all		
		end
end