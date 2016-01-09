class UsersController < ApplicationController

  before_action :signed_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  	#@user = User.find(params[:id])
    #@microposts = @user.microposts.paginate(page: params[:params])
    default_data
  end

  def show_reviews
    @reviews_tab_active = true
    default_data
  end

  def show_following
    @following_tab_active = true
    default_data
  end

  def show_followers
    @followers_tab_active = true
    default_data
  end

  def show_top_reviews
    @reviews_tab_active = true
    @reviews_top_rated_tab_active = true
    default_data
  end

  def show_newest_reviews
    @reviews_tab_active = true
    @reviews_newest_tab_active = true
    default_data
  end

  def new
    if signed_in?
      flash[:error] = "Sign out to create a new account"
      redirect_to root_url
    else
  	  @user = User.new
    end
  end

  def create
    if signed_in?
      flash[:error] = "Sign out to create a new account"
      redirect_to root_url
    else
      @user = User.new(user_params)
  	  if @user.save
        sign_in @user
        flash[:success] = "Welcome to the Sample App!"
  		  redirect_to @user
  	  else
  		  render 'new'
  	  end
    end
  end

  def edit
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    unless current_user?(user)
      user.destroy
      flash[:success] = "User deleted."
    end
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.followed_users.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    # Before filters

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    def default_data
      @invert_header = true
      @is_user_logged_in = true
      @popular_albums = StaticPagesHelper::SAMPLE_DATA.popular_albums
      @album_feeds = StaticPagesHelper::SAMPLE_DATA.album_feeds
      @top_writers = StaticPagesHelper::SAMPLE_DATA.top_writers
      @users = StaticPagesHelper::SAMPLE_DATA.top_writers(10)
      @tags = StaticPagesHelper::SAMPLE_DATA.tags
      @viewing_own_profile = [true,false].sample
      @profile_id = params[:profile_id] ? params[:profile_id] : 'Jess Smith'
    end
end
