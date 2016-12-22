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

      @searchresults = @searchresults.to_json(:methods => :info)

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
      result.info = take_all_relevant_sentences_from_string(result.description, keywords, result.title)
        result.arguments.each do |argument|
          result.info.push(*take_all_relevant_sentences_from_string(argument.description, keywords, argument.title))
        end
    end

    return searchresults
  end

  def take_all_relevant_sentences_from_string(text, keywords, title)

    all_relevant_sentences =[]

    sentences = text.split('.')

    keywords.split.each do |keyword|all_relevant_sentences

      sentences.each do |sentence|

        if sentence.include?(keyword)
          all_relevant_sentences.push("In #{title} ==> " + sentence)
        end
      end
    end

    all_relevant_sentences = all_relevant_sentences.uniq

    return all_relevant_sentences

  end

end
