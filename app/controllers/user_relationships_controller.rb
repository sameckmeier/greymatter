class UserRelationshipsController < ApplicationController
	before_action :signed_in_user

	def create
		@user = User.find(params[:followed_user_id])
		current_user.follow!(:user, @user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		@user = UserRelationship.find(params[:user_id]).followed
		current_user.unfollow!(:user, @user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end
