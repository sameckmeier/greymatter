class SessionController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:session][:email].downcase)

    if user && user.authenticate(params[:session][:password])

      store_session_token user
      log_in user
      redirect_to user

    else

      flash[:danger] = "There's something fishy with your email and/or password"
      render :new
    end
  end

  def destroy

    log_out user
    redirect_to "/"
  end
end
