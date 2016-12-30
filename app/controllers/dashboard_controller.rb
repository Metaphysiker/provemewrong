class DashboardController < ApplicationController
  def index
    @argumentation = Argumentation.all
  end

  def test
    @searchterm = params[:searchterm]
  end

  def get_current_user
    @id = 0
    if current_user
      @id = current_user.id
    end

    respond_to do |format|
      format.json { render json: @id}
    end
  end
end