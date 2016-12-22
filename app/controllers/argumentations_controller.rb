class ArgumentationsController < ApplicationController
  PAGE_SIZE = 10

    def index
      @page = (params[:page] || 0).to_i
      if params[:keywords].present?
        @keywords = params[:keywords]


        foundargumentations = Argumentation.searchfor(@keywords)

        foundarguments = Argument.searchfor(@keywords)

        foundargumentationswitharguments = Argumentation.where(id: foundarguments.all.pluck(:parent_argumentation_id))

        @argumentations = foundargumentations.merge(foundargumentationswitharguments).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)

        #@argumentations = Argument.searchfor(@keywords).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)

        #@argumentations = Argumentation.joins(:arguments).where(Argument.searchfor(@keywords))
        #

        #@argumentations = Argumentation.searchfor(@keywords).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
        #@argumentations = SearchResults.searchfor(@keywords).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)

      # argumentations = Argumentation.searchfor(@keywords).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)

        #@argumentations = Argumentation.search_argumentations_and_arguments(@keywords).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)
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


  private

  def show_only_important_info(searchresults)
    finalresult = []

    searchresults.each do |result|


    end

  end

end
