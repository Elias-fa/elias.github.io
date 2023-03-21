class UsersController < ApplicationController
  #before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update, :destroy]

  # def index
  #   @users = User.not_admins
  # end

  def show
    @user = User.find(params[:id])
    @current_user = current_user
    @rooms = Room.public_rooms
    @users = User.all_except(@current_user)
    @room = Room.new
    @message = Message.new
    @room_name = get_name(@user, @current_user)
    @single_room = Room.where(name: @room_name).first || Room.create_private_room([@user, @current_user], @room_name)
    @messages = @single_room.messages

    render "rooms/index"
  end

  def new 
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Thanks for signing up!"
    else
      render :new, status: :unprocessable_entity
    end
  end


  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :edit
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil 
    redirect_to root_path, alert: "Account successfully deleted!"
  end
  
  private

  def get_name(user1, user2)
    users = [user1, user2].sort
    "private_#{users[0].id}_#{users[1].id}"
  end

  def require_correct_user
    @user = User.find(params[:id])
      redirect_to root_path unless current_user?(@user)
  end
  
  def user_params
    params.require(:user).
      permit(:name, :email, :password, :password_confirmation, :username)
  end
end
