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

        @searchresults = show_only_important_info_of(argumentations, @keywords)

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

      logger.debug @searchresults.last.info.inspect
      @searchresults = @searchresults.to_json(:methods => :info)
      logger.debug @searchresults

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

  def show_only_important_info_of(searchresults, keywords)

    return searchresults if searchresults.nil? || searchresults.empty?

    searchresults.each do |result|
      result.arguments.each do |argument|
        all_relevant_sentences =[]

        sentences = argument.description.split('.')

        keywords.split.each do |keyword|

          sentences.each do |sentence|

            if sentence.include?(keyword)
              all_relevant_sentences.push("In #{argument.title}: " + sentence)
            end
          end
        end

        result.info = all_relevant_sentences
      end
    end

    return searchresults
  end

end
