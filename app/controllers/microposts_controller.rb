class MicropostsController < ApplicationController
before_action :logged_in_user, only: [:create, :destroy]

  def create
    @feed_items2 = @feed_items
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost has been created!"
      Rails::logger.debug @micropost.content
      redirect_to root_path
    else
      @feed_items = []
      # redirect_to root_path
      # flash[:danger] = "Fail!"
      render 'static_pages/home'
      # render partial: 'shared/micropost_form'
    end
  end

  def destroy

  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

end
