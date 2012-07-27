class UsersController < ApplicationController
	def index
		# Find all users
		@records = User.order("name ASC").all
	end
	
	def edit
		# Try to find the user. If id is 0, then we are creating
		@id = params[:id].to_i
		
		begin
			@record = (@id > 0) ? User.find(@id) : User.new
		rescue ActiveRecord::RecordNotFound => e
			@record = nil
		end
		
		if request.get? then # On GET requested, we show the form
			@editing = @record.present? ? !@record.new_record? : false			
		else 
			if @record then # If the record is either found or new
				name = (params[:user] && params[:user][:name] ? params[:user][:name] : "").strip # Get the name
				
				begin
					@record.name = name
					@record.save!
				rescue ActiveRecord::RecordInvalid => e # Javascript can fail, so double check here
					redirect_to :action => :edit, :id => @id, :errors => "name"
					return
				end
			end

			# Back to the list
			redirect_to :action => :index
		end
	end
	
	def remove
		begin
			User.destroy(params[:id].to_i)
		rescue ActiveRecord::RecordNotFound => e
		end
		
		# Back to the list. No error reporting
		redirect_to :action => :index
	end
	
	def show
		begin
			@record = User.find(params[:id].to_i)
		rescue ActiveRecord::RecordNotFound => e
			@record = nil
		end
		
		redirect_to :action => :index if @record.blank? # If we didn't found the user
	end
	
	def follow
		created = false
		
		begin
			# Find the users
			owner = User.find(params[:owner_id].to_i)
			user = User.find(params[:user_id].to_i)

			if (request.format != :json || request.post?) && owner && user then # Create the relation
				created = Follow.create({:owner => owner, :user => user}).valid?				
			end				
		rescue ActiveRecord::RecordNotFound => e
		end

		# Back to the details or JSON. No error reporting.
		if request.format != :json then
			redirect_to :action => :show, :id => params[:owner_id].to_i
		else
			render :json => {:success => created}
		end
	end
	
	def unfollow
		owner_id = 0
		deleted = false
		
		begin
			followed = Follow.find(params[:follow_id].to_i)
			
			if (request.format != :json || request.post?) && followed then
				owner_id = followed.owner_id if followed # Get owner id for the redirect
				followed.delete
				deleted = true
			end
		rescue ActiveRecord::RecordNotFound => e
		end
		
		# Back to the details or JSON. No error reporting.
		if request.format != :json then
			redirect_to :action => :show, :id => owner_id.to_i
		else
			render :json => {:success => deleted}
		end
	end
	
	def available
		name = (params[:name] || "").strip
		id = params[:id].to_i
		
		# The name is valid if not taken. We exclude the calling user with the id field.
		render :json => {:reply => (name.present? && User.where("id != :id AND name = :name", {:id => id, :name => name}).count == 0)} 
	end
end
