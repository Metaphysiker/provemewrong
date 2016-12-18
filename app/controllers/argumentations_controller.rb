class ArgumentationsController < ApplicationController


  def show
    argumentation = Argumentation.find(params[:id])
    arguments = argumentation.arguments
    sleep 2

    both = {argumentation: argumentation, arguments: arguments}
    respond_to do |format|
      format.json { render json: both }
    end
  end

  def get_child_argumentation
    argument = Argument.find(params[:id])
    argumentation = argument.argumentation
    arguments = argumentation.arguments
    sleep 2

    both = {argumentation: argumentation, arguments: arguments}
    respond_to do |format|
      format.json { render json: both }
    end
  end

  private


end
