class ReviewsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:destroy]

	def create
		@review = Review.build(params)

		if @review
			flash[:success] = "Review created!"
			redirect_to root_url
		else
			flash[:failure] = "Something Went Wrong! We're looking into it"
			render 'static_pages/home'
		end
	end

	def destroy
		@review.destroy
		redirect_to root_url
	end

	private

	def correct_user
		@review = current_user.reviews.find_by(id: params[:review_id]) #does find work?
		redirect_to root_url if @review.nil?
	end
end
