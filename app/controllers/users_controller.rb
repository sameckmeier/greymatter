class UsersController < ApplicationController

  def index
    #pagination
  end

  def show
    @user = User.find(params[:user_id])
  end

  def new

    if signed_in?

      flash[:alert] = "You need to sign out before creating another account"
      redirect_to "/"

    else

      @user = User.new
    end
  end

  def create

    @user = User.new(user_fields)

    if user_exists?

    elsif @user.save

    else
      
    end
  end

  def edit
  end

  def update

  end

  def destroy

  end

  def following

  end

  def followers

  end

  private

  def signed_in?
  end

  def user_fields
  end

end
