class ImportantBits

  def initialize(foundargumentations, foundarguments, offset, limit, keywords)
    @foundargumentations = foundargumentations
    Rails.logger.debug @foundargumentations.count.inspect
    @foundarguments = foundarguments
    Rails.logger.debug "foundarguments: #{@foundarguments.count.inspect}"
    @offset = offset
    @limit = limit
    @keywords = keywords
    @searchresults = ""
  end

  def get_all_bits
    foundargumentationswitharguments = Argumentation.where(id: @foundarguments.all.pluck(:parent_argumentation_id))
    Rails.logger.debug "all-pluck #{foundargumentationswitharguments.count.inspect}"

    #argumentations = @foundargumentations.merge(foundargumentationswitharguments) #.offset(@offset).limit(@limit)
    #argumentations = @foundargumentations.or(foundargumentationswitharguments) #.offset(@offset).limit(@limit)
    argumentations = @foundargumentations.union(foundargumentationswitharguments)
    argumentations.offset(@offset).limit(@limit)


    Rails.logger.debug argumentations.count.inspect
    Rails.logger.debug "heeey"

    @searchresults = get_important_bits(argumentations, @keywords)
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