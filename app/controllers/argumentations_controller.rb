class ArgumentationsController < ApplicationController
  PAGE_SIZE = 10

    def index
      @page = (params[:page] || 0).to_i
      if params[:keywords].present?
        @keywords = params[:keywords]

        #@argumentations = Argumentation.searchfor(@keywords).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
        @argumentations = SearchResults.searchfor(@keywords).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
      else
        @argumentations = []
      end

      respond_to do |format|
        format.json { render json: @argumentations }
      end

    end

  def show
    #argumentation = Argumentation.find(params[:id])
    #arguments = argumentation.arguments
    #sleep 2

    #both = {argumentation: argumentation, arguments: arguments}
      argumentation = Argumentation.find(params[:id])

      respond_to do |format|
        format.json { render json: argumentation.as_json(include: {arguments: { include: :argumentation}}) }
      end

  end

end
