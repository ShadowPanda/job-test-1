require 'spec_helper'

describe User do
	before(:each) do
		@user1 = User.create({:name => "user-1"})
		@user2 = User.create({:name => "user-2"})
		@user3 = User.create({:name => "user-3"})
		@user4 = User.create({:name => "user-4"})
		@follow1 = Follow.create({:owner => @user1, :user => @user2})
		@follow2 = Follow.create({:owner => @user1, :user => @user3})
		@follow3 = Follow.create({:owner => @user1, :user => @user4})
		@follow4 = Follow.create({:owner => @user2, :user => @user1})		
	end
	
	it "can be instantiated" do
		user = User.new
		user.name = 'user-0'
		user.name.should == 'user-0'
	end

	it "cannot be created without name" do 
		expect { User.create! }.to raise_error(ActiveRecord::RecordInvalid)
	end

	it "cannot have the name of another user" do 
		expect { User.create!({:name => "user-1"}) }.to raise_error(ActiveRecord::RecordInvalid)
	end	
	
	it "has followings" do
		@user1.followings.count.should == 3
		@user1.followings.first.owner.name.should == @user1.name
		@user1.followings.first.user.name.should == @user2.name
		@user3.followings.count.should == 0
	end
	
	it "has unfollowings" do
		@user1.unfollowings.count.should == 0			
		@user2.unfollowings.count.should == 2
		@user2.unfollowings.first.name.should == "user-3"
	end
	
	it "is followed by" do
		@user1.followed_by.count.should == 1
		@follow3.delete
		@user4.followed_by.count.should == 0		
	end
	
	it "does not leave orphaned follows" do
		id = @user1.id
		@user1.destroy
		Follow.where(:owner_id => id).count.should == 0
		Follow.where(:user_id => id).count.should == 0		
	end
end