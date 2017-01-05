class ArgumentationsController < ApplicationController
  before_action :find_argumentation, only: [:show, :update, :deleteargumenttoargumentation, :addargumentationtoargument, :addargumenttoargumentation, :deletefullargumentation]

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
      user_allowed?(@argumentation.user_id)

      respond_to do |format|
        format.json {
            render json: @argumentation.as_json(include: {arguments: { include: :argumentation}})
        }
      end

  end

  def create

    argumentation = Argumentation.create!(title: "Insert title here!", description: "Insert description here!")

    if params[:main].present?
      main = params[:main]
      argument = Argument.find(params[:argumentid])
      argument.argumentation = argumentation
    else
      main = argumentation.id
    end

    argumentation.update(main: main)
    current_user.argumentations << argumentation

    argument = Argument.create!(title: "Insert argument-title here!", description: "Insert description of argument here!")
    argumentation.arguments << argument
    argument.add_place

    respond_to do |format|
      format.json { render json: argumentation.as_json(include: {arguments: { include: :argumentation}}) }
    end
  end

  def update

    @argumentation.update(argumentation_params)
    updatearguments(params[:arguments])
    head :ok

    #if user_allowed?(argumentation.user_id)
      #updatearguments(params[:arguments])

      #argumentation.update(argumentation_params)
     # head :ok
    #else
     # head :forbidden
    #end
  end

  def getparentargumentation

    argument = Argument.find(params[:id])

    argumentation = Argumentation.find(argument.parent_argumentation_id)

    respond_to do |format|
      format.json { render json: argumentation.as_json(include: {arguments: { include: :argumentation}}) }
    end
  end

  def addargumentationtoargument
    argumentation = Argumentation.find(params[:id])
  end

  def addargumenttoargumentation
    argument = Argument.create(title: "Insert Title here!", description: "Insert argument here!")
    @argumentation.arguments << argument
    argument.add_place

    respond_to do |format|
      format.json { render json: @argumentation.as_json(include: {arguments: { include: :argumentation}}) }
    end

  end

  def deleteargumenttoargumentation

    place = params[:place]

    argument = @argumentation.arguments.where(place: place)

    Argument.destroy(argument.first.id)

    @argumentation.reorder_place(place)

    respond_to do |format|
      format.json { render json: @argumentation.as_json(include: {arguments: { include: :argumentation}}) }
    end

  end

  def deletefullargumentation
    @argumentation.destroy
    head :ok
  end

  def myargumentations

    @argumentations = current_user.argumentations.where('id = main')

    respond_to do |format|
      format.json { render json: @argumentations }
    end
  end

  private

  def updatearguments(list_of_arguments)
    list_of_arguments.each do |argument|
      argumentu = Argument.find(argument[:id])
      #argument_hash = {"title" => argument[:title], "description" => argument[:description]}
      argument_params = ActionController::Parameters.new({
                                                        title: argument[:title],
                                                        description:  argument[:description],
                                                        place: argument[:place]
                                                })
      argumentu.update(argument_params.permit(:title, :description, :place))
    end
  end

  def argumentation_params
    params.permit(:title, :description, :arguments, pets_attributes: [:id, :title, :description, :place])
  end

  def argument_params
    params.permit(:title, :description)
  end

  def user_allowed?(user_id)
    if current_user.id != user_id
      @argumentation = {title: "you are not allowed"}
    end
  end

  def find_argumentation
    @argumentation = Argumentation.find(params[:id])
  end

end
