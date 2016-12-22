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

  def get_important_bits(argumentations, keywords)
    argumentations.each do |argumentation|
      argumentation.info = []
      bits = get_bits(argumentation.title, argumentation.description, keywords)
      argumentation.info.push(bits) unless bits.empty?
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

  def show_only_important_info_of(searchresults, keywords)

    return searchresults if searchresults.nil? || searchresults.empty?

    searchresults.each do |result|
      relevant_infos = take_all_relevant_sentences_from_string(result.description, keywords, result.title)
      result.info.push("jesus") unless relevant_infos.nil?
        result.arguments.each do |argument|
          relevant_sentences = take_all_relevant_sentences_from_string(argument.description, keywords, argument.title)
          result.info.push("moses") unless relevant_sentences.nil?
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
          all_relevant_sentences.push(sentence)
        end
      end
    end

    all_relevant_sentences = all_relevant_sentences.uniq

    relevant_information_with_title = {"title" => title, "results" => all_relevant_sentences}
    return relevant_information_with_title

  end

end
