class ArgumentationsController < ApplicationController
  PAGE_SIZE = 10

    def index
      @page = (params[:page] || 0).to_i
      if params[:keywords].present?
        @keywords = params[:keywords]


        foundargumentations = Argumentation.searchfor(@keywords)

        foundarguments = Argument.searchfor(@keywords)

        foundargumentationswitharguments = Argumentation.where(id: foundarguments.all.pluck(:parent_argumentation_id))

        argumentations = foundargumentations.merge(foundargumentationswitharguments).offset(PAGE_SIZE * @page).limit(PAGE_SIZE)

        @searchresults = get_important_bits(argumentations, @keywords)

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


  private

  def get_important_bits(argumentations, keywords)
    argumentations.each do |argumentation|
      argumentation.infomain = []
      argumentation.info = []
      bits = get_bits(argumentation.title, argumentation.description, keywords)
      argumentation.infomain.push(bits) unless bits.empty?
      argumentation.arguments.each do |argument|
        bitsfromarguments = get_bits(argument.title, argument.description, keywords)
        argumentation.info.push(bitsfromarguments) unless bitsfromarguments.blank?
      end
    end

    return argumentations
  end

  def get_bits(title, text, keywords)
    all_relevant_sentences =[]
    sentences = text.split('.')
    sentences.each do |sentence|
      keywords.split.each do |keyword|
        if sentence.include?(keyword)
          all_relevant_sentences.push(sentence)
          break
        end
      end
    end

    return [] if all_relevant_sentences.empty?

    return {"title" => title, "bits" => all_relevant_sentences}

  end

end
