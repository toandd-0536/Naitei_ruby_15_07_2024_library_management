class Admin::UsersController < AdminController
  before_action :load_user, except: %i(index)

  def index
    @q = User.ransack(params[:q])
    @pagy, @users = pagy(@q.result, items: Settings.page)
    @breadcrumb_items = [{name: t(".index.title")}]
  end

  def show
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_users_path},
      {name: @user.name}
    ]
  end

  def edit
    @breadcrumb_items = [
      {name: t(".index.title"), url: admin_users_path},
      {name: @user.name, url: admin_user_path(@user)},
      {name: t(".edit.title")}
    ]
  end

  def update
    if @user.update user_params
      flash[:success] = t "message.users.updated"
      redirect_to admin_user_path(@user)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "message.users.deleted"
    else
      flash[:danger] = t "message.delete_fail"
    end
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit User::USER_PARAMS
  end

  def load_user
    @user = User.find_by id: params[:id]
    return if @user

    flash[:danger] = t "message.users.not_found"
    redirect_to root_url
  end
end
