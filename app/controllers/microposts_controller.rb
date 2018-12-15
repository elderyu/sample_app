class MicropostsController < ApplicationController
before_action :logged_in_user, only: [:create, :destroy]
before_action :correct_user, only: [:destroy]

  def create
    @feed_items2 = @feed_items
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost has been created!"
      Rails::logger.debug @micropost.content
      redirect_to root_path
    else
      @feed_items = feed_microposts # tymczasowe, bo kod powtarza się w dwóch miejscach, można wrzucić to w funkcję i do aplicationhelpera
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted!"
    redirect_to request.referrer || root_path
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    def correct_user
      @micropost = current_user.microposts.find_by id: params[:id]
      # redirect if micropost doesnt exist
      redirect_to root_path if @micropost.nil?
    end

end
