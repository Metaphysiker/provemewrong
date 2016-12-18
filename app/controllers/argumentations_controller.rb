class ArgumentationsController < ApplicationController


  def show
    #argumentation = Argumentation.find(params[:id])
    #arguments = argumentation.arguments
    sleep 2

    #both = {argumentation: argumentation, arguments: arguments}
    argumentation = Argumentation.find(params[:id])

    respond_to do |format|
      format.json { render json: argumentation.as_json(include: {arguments: { include: :argumentation}}) }
    end
  end

end
