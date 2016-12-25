class DashboardController < ApplicationController
  def index
    @argumentation = Argumentation.all
  end

  def test
    @searchterm = params[:searchterm]
  end
end