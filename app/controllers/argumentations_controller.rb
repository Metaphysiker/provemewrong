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

  def create
    argumentation = Argumentation.create!(title: "Insert title here!", description: "Insert description here!")
    argumentation.update(main: argumentation.id)
    current_user.argumentations << argumentation

    argument = Argument.create!(title: "Insert argument-title here!", description: "Insert description of argument here!")
    argumentation.arguments << argument

    respond_to do |format|
      format.json { render json: argumentation.as_json(include: {arguments: { include: :argumentation}}) }
    end
  end

  def update

    argumentation = Argumentation.find(params[:id])

    updatearguments(params[:params][:arguments])

    argumentation.update(argumentation_params)
    head :ok

  end

  def getparentargumentation

    argument = Argument.find(params[:id])

    argumentation = Argumentation.find(argument.parent_argumentation_id)

    respond_to do |format|
      format.json { render json: argumentation.as_json(include: {arguments: { include: :argumentation}}) }
    end
  end

  private

  def updatearguments(list_of_arguments)
    Rails::logger.debug "list_of_arguments: #{list_of_arguments.inspect}"
    list_of_arguments.each do |argument|
      argumentu = Argument.find(argument[:id])
      #argument_hash = {"title" => argument[:title], "description" => argument[:description]}
      argument_params = ActionController::Parameters.new({
                                                        title: argument[:title],
                                                        description:  argument[:description]
                                                })
      argumentu.update(argument_params.permit(:title, :description))
    end
  end

  def argumentation_params
    params.require(:params).permit(:title, :description, :arguments, pets_attributes: [:id, :title, :description])
  end

  def argument_params
    params.permit(:title, :description)
  end

end
