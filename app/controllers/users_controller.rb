class UsersController < ApplicationController

  include SessionsHelper

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

    if @user.save

      flash[:message] = "Booya! Account Created!"
      log_in @user
      redirect_to @user

    else

      flash[:alert] = "Sorry, that email's been taken"
      render :new
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

  def user_fields
    params.require(:user).permit(:username, :email, :password, :password_confirmation)
  end

end
