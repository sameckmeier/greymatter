class ReviewsController < ApplicationController
	before_action :signed_in_user, only: [:create, :destroy]
	before_action :correct_user, only: [:destroy]

	def create
		album = Album.where(spotify_id: params[:spotify_id]) || Album.build(params[:album])
		@review = Review.build(current_user, album, params[:content])

		if @review
			flash[:success] = "Review created!"
			redirect_to root_url
		else
			flash[:failure] = "Something Went Wrong! We're looking into it"
			render 'static_pages/home'
		end
	end

	def destroy
		review = current_user.reviews.find_by(id: params[:review_id])
		if review
			Review.find(review.id).destroy!
		end
		redirect_to root_url
	end
end
