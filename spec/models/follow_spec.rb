require 'spec_helper'

describe Follow do
	before(:each) do
		@user1 = User.create({:name => "user-1"})
		@user2 = User.create({:name => "user-2"})
		@follow1 = Follow.create({:owner => @user1, :user => @user2})
	end
	
	it "can be instantiated" do
		follow = Follow.new		
	end

	it "has an owner" do 
		@follow1.owner.should_not be_nil
		@follow1.owner.name.should == "user-1" 
	end

	it "has a user" do 
		@follow1.user.should_not be_nil
		@follow1.user.name.should == "user-2" 
	end
	
	it "cannot follow itself" do
		expect { Follow.create!({:owner => @user1, :user => @user1}) }.to raise_error(ActiveRecord::RecordInvalid)		
	end
	
	it "cannot follow an user twice" do
		expect { Follow.create!({:owner => @user1, :user => @user2}) }.to raise_error(ActiveRecord::RecordInvalid)
	end
end