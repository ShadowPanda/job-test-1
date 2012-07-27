#encoding: utf-8

class Follow < ActiveRecord::Base
	belongs_to :owner, :class_name => "User"
	belongs_to :user		
	
	validate :not_following_it_self
	validates_uniqueness_of :user_id, :scope => [:owner_id], :message => "the owner is already following the user."
	
	def not_following_it_self
		errors.add(:user_id, "can't follow itself.") if self.owner_id == self.user_id
	end
end