class DashboardController < ApplicationController
  def index
    @argumentation = Argumentation.all
  end
end