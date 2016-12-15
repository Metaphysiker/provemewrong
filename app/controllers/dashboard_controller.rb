class DashboardController < ApplicationController
  def index
    @argumentation = Argumentation.all
  end

  def test
  end
end