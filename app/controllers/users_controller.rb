class UsersController < ApplicationController
before_action :require_user, except: [:index, :sign_in, :login, :new, :create]

  def index
    if current_user
      @usershows = current_user.shows
      @useralbums = current_user.albums
      @usermovies = current_user.movies
      userinfo
      sample if current_user.stackings == []
      render :index
    else
      render :landing
    end
  end

  # GET /users/new
  def new
    @user = User.new
    render :sign_up
  end

  # GET /login
  def sign_in
    render :login
  end

  # POST /login
  def login
    @user = User.find_by(email: params[:loginuser][:email])
    if @user
      if @user.authenticate(params[:loginuser][:password])
        session[:email] = @user.email
        respond_to do |format|
          format.html { redirect_to :root , notice: "Successfully logged in as #{@user.email}" }
        end
      else
        respond_to do |format|
          format.html { redirect_to :back , notice: 'Invalid User or Password'}
        end
      end
    else
      respond_to do |format|
        format.html { redirect_to :back , notice: 'Invalid User or Password'}
      end
    end
  end

  # DELETE /logout
  def logout
    session[:email] = nil
    respond_to do |format|
      format.html { redirect_to :root , notice: 'Successfully logged out.'}
    end
  end

  # POST /users/new
  def create
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        session[:email] = @user.email
        format.html { redirect_to root_path , notice: 'User was successfully created.' }
      else
        format.html { render :sign_up}
      end
    end
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end


end
