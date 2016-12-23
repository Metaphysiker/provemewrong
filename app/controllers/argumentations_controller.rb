class ArgumentationsController < ApplicationController
  PAGE_SIZE = 10

    def index
      @page = (params[:page] || 0).to_i

      if params[:keywords].present?
        @keywords = params[:keywords]

        allbits = ImportantBits.new(Argumentation.searchfor(@keywords),
                                    Argument.searchfor(@keywords),
                                    PAGE_SIZE * @page,
                                    PAGE_SIZE,
                                    @keywords)

        @searchresults = allbits.get_all_bits

      else
        @searchresults = []
      end

      @searchresults = @searchresults.to_json(:methods => [:info, :infomain])

      respond_to do |format|
        format.json { render json: @searchresults }
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
