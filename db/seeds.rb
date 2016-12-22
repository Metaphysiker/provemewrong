# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env == 'development'

  User.create!(email: "s.raess@me.com", password: "password")


  500.times do |i|
    puts "I is: #{i}"
    argumentation =Argumentation.create!(
                     title: Faker::Lorem.sentence,
                     description: Faker::Lorem.paragraph(80, true, 20)
                    )
    rand(5..12).times do |x|
      argu =Argument.create!(
          title: Faker::Lorem.sentence,
          description: Faker::Lorem.paragraph(80, true, 20)
      )

      argumentation.arguments << argu

      if x.odd?
        childargumentation =Argumentation.create!(
            title: Faker::Lorem.sentence,
            description: Faker::Lorem.paragraph(80, true, 20)
        )

        argu.argumentation = childargumentation
      end


    end

  end

  zynix = Argumentation.create!(title: "zynixumik", description: "zynixumik")
  zynix1 = Argument.create!(title: "zynixumik", description:"zynixumik")
  zynix2 = Argument.create!(title: "zynixumik", description:"zynixumik")
  zynix3 = Argument.create!(title: "zynixumik", description:"zynixumik")
  zynix.arguments << zynix1
  zynix.arguments << zynix2
  zynix.arguments << zynix3



  argu1 = Argumentation.create!(title: "Why we should read classics in the school", description: "This argumentation has three arguments: 1. Classics are full of wisdoms, 2. deliver life-experiences, 3. belong to our culture")
  a1 = Argument.create!(title: "Classics are full of wisdeom and therefore worth reading", description: " Functionings are ‘beings and doings’, that is, various states of human beings and activities that a person can undertake. Examples of the former (the ‘beings’) are being well-nourished, being undernourished, being housed in a pleasantly warm but not excessively hot house, being educated, being illiterate, being part of a supportive social network, being part of a criminal network, and being depressed. Examples of the second group of functionings (the ‘doings’) are travelling, caring for a child, voting in an election, taking part in a debate, taking drugs, killing animals, eating animals, consuming lots of fuel in order to heat one's house, and donating money to charity.

From these examples we can draw a couple of observations. First, these examples indicate that many features of a person could be described either as a being or as a doing: we can say that a person is housed in a pleasantly warm house, or that this person does consume lots of energy to keep her house warm. Yet other functionings are much more straightforwardly described as either a being or a doing, for example ‘being healthy’ or ‘killing animals’. The second observation is that the notion of ‘functionings’ is a conceptual category that is in itself morally neutral. Functionings can be univocally good (e.g., being in good health) or univocally bad (e.g., being raped). But the goodness or badness of various other functionings may not be so straightforward, but rather depend on the context and/or the normative theory which we endorse. For example, is the care work of a mother who is caring full-time for her child a valuable functioning or not? A conservative-communitarian normative theory will most likely mark this as a valuable functioning, whereas a feminist-liberal theory will only do so if the care work is the result of an autonomous choice made against a background of equal opportunities and fair support for those who have duties to care for dependents.

Capabilities are a person's real freedoms or opportunities to achieve functionings. Thus, while travelling is a functioning, the real opportunity to travel is the corresponding capability. The distinction between functionings and capabilities is between the realized and the effectively possible, in other words, between achievements, on the one hand, and freedoms or valuable opportunities from which one can choose, on the other.")
  a2 = Argument.create!(title: "Some experiences cant be made with living", description: " According to the capability approach, ‘functionings’ and ‘capabilities’ are the best metric for most kinds of interpersonal evaluations. In other words, those interpersonal evaluations should be conceptualized in terms of people's functioning (their actual beings and doings) and their capabilities (the real opportunities they have to realise those functionings). These beings and doings together are held to constitute what makes a life valuable. Whereas ‘functionings’ are the proposed conceptualization for interpersonal comparisons of (achieved) well-being, ‘capabilities’ are the conceptualization for interpersonal comparisons of the freedom to pursue well-being, which Sen calls “well-being freedom” (Sen 1992: 40).

The relevant functionings can vary from such elementary things as being adequately nourished, being in good health, avoiding escapable morbidity and premature mortality, to more complex achievements such as having a decent and valuable job, not suffering from lack of self-respect, taking active part in the life of the community, and so on. The claim is that functionings are constitutive of a person's being, and an evaluation of well-being has to take the form of an assessment of these constituent elements (Sen 1992: 39). To say that functionings are constitutive of a person's being means that one cannot be a human being without having at least a range of functionings: they make the lives of human beings both lives (in contrast to the existence of innate objects) and also human (in contrast to the lives of trees or tigers). Human functionings are those beings and doings that we take to constitute a human life, and which are central in our understandings of ourselves as human beings. This implies that the range of potentially relevant functionings is very broad, and that the capability approach will in some respects be close to both subjective metrics (for example, by including the capability to be happy), or resources-based metrics (since most functionings require some resources as inputs). Yet not all beings and doings are functionings; for example, being able to fly like a bird or reaching an age of 200 like an oak tree, are not human functionings.

Thus, according to the capability approach, the ends of well-being freedom, justice, and development should be conceptualized in terms of people's capabilities. Moreover, what is relevant is not only which opportunities are open to me each by themselves, hence in a piecemeal way, but rather which combinations or sets of potential functionings are open to me. For example, suppose I am a low-skilled poor single parent who lives in a society without decent social provisions. Take the following functionings: (1) to hold a job, which will require me to spend many hours on working and commuting, but will generate the income needed to properly feed myself and my family; (2) to care for my children at home and give them all the attention, care and supervision they need. In a piecemeal analysis, both (1) and (2) are opportunities open to me, but they are not both together open to me. The point about the capability approach is precisely that we must take a comprehensive or holistic approach, and ask which sets of capabilities are open to me, that is: can I simultaneously provide for my family and properly care for and supervise my children? Or am I rather forced to make some hard, perhaps even tragic choices between two functionings which both reflect basic needs and basic moral duties?

Note that while most types of capability analysis require interpersonal comparisons, one could also use the capability approach to evaluate the well-being or well-being freedom of one person at one point in time (e.g., evaluate her situation against a capability-yardstick), or to evaluate the changes in her well-being or well-being freedom over time. The capability approach could thus also be used by a single individual in her deliberate decision-making or evaluation processes, but these types of uses of the capability approach are much less prevalent in the philosophical literature, let alone in the social sciences.")
  a3 = Argument.create!(title: "Culture is intellectually important", description: " According to the capability approach, ‘functionings’ and ‘capabilities’ are the best metric for most kinds of interpersonal evaluations. In other words, those interpersonal evaluations should be conceptualized in terms of people's functioning (their actual beings and doings) and their capabilities (the real opportunities they have to realise those functionings). These beings and doings together are held to constitute what makes a life valuable. Whereas ‘functionings’ are the proposed conceptualization for interpersonal comparisons of (achieved) well-being, ‘capabilities’ are the conceptualization for interpersonal comparisons of the freedom to pursue well-being, which Sen calls “well-being freedom” (Sen 1992: 40).

The relevant functionings can vary from such elementary things as being adequately nourished, being in good health, avoiding escapable morbidity and premature mortality, to more complex achievements such as having a decent and valuable job, not suffering from lack of self-respect, taking active part in the life of the community, and so on. The claim is that functionings are constitutive of a person's being, and an evaluation of well-being has to take the form of an assessment of these constituent elements (Sen 1992: 39). To say that functionings are constitutive of a person's being means that one cannot be a human being without having at least a range of functionings: they make the lives of human beings both lives (in contrast to the existence of innate objects) and also human (in contrast to the lives of trees or tigers). Human functionings are those beings and doings that we take to constitute a human life, and which are central in our understandings of ourselves as human beings. This implies that the range of potentially relevant functionings is very broad, and that the capability approach will in some respects be close to both subjective metrics (for example, by including the capability to be happy), or resources-based metrics (since most functionings require some resources as inputs). Yet not all beings and doings are functionings; for example, being able to fly like a bird or reaching an age of 200 like an oak tree, are not human functionings.

Thus, according to the capability approach, the ends of well-being freedom, justice, and development should be conceptualized in terms of people's capabilities. Moreover, what is relevant is not only which opportunities are open to me each by themselves, hence in a piecemeal way, but rather which combinations or sets of potential functionings are open to me. For example, suppose I am a low-skilled poor single parent who lives in a society without decent social provisions. Take the following functionings: (1) to hold a job, which will require me to spend many hours on working and commuting, but will generate the income needed to properly feed myself and my family; (2) to care for my children at home and give them all the attention, care and supervision they need. In a piecemeal analysis, both (1) and (2) are opportunities open to me, but they are not both together open to me. The point about the capability approach is precisely that we must take a comprehensive or holistic approach, and ask which sets of capabilities are open to me, that is: can I simultaneously provide for my family and properly care for and supervise my children? Or am I rather forced to make some hard, perhaps even tragic choices between two functionings which both reflect basic needs and basic moral duties?

Note that while most types of capability analysis require interpersonal comparisons, one could also use the capability approach to evaluate the well-being or well-being freedom of one person at one point in time (e.g., evaluate her situation against a capability-yardstick), or to evaluate the changes in her well-being or well-being freedom over time. The capability approach could thus also be used by a single individual in her deliberate decision-making or evaluation processes, but these types of uses of the capability approach are much less prevalent in the philosophical literature, let alone in the social sciences.")
  argu1.arguments << a1
  argu1.arguments << a2
  argu1.arguments << a3

  argu2 = Argumentation.create!(title: "Someone is rational, if the person is responsive for good reasons", description: "This argumentation has two arguments: 1. Everyone makes mistakes, but if one repeats them, he is acting irrationally. 2. Good reasons are necessary")
  a2 = Argument.create!(title: "Making mistakes is nothing special, but repeating them, knowingly is irrationally", description: " Another important idea in the capability approach, especially in the work by Amartya Sen (1992: 19–21, 26–30, 37–38) and scholars influenced by his writings, is the notion of conversion factors. Resources, such as marketable goods and services, but also goods and services emerging from the non-market economy, including household production, have certain characteristics that make them of interest to people. For example, we may be interested in a bike not because it is an object made from certain materials with a specific shape and color, but because it can take us to places where we want to go, and in a faster way than if we were walking. These characteristics of a good or commodity enable or contribute to a functioning. A bike enables the functioning of mobility, to be able to move oneself freely and more rapidly than walking. The relation between a good and the achievement of certain beings and doings is captured with the term ‘conversion factor’: the degree in which a person can transform a resource into a functioning. For example, an able bodied person who was taught to ride a bicycle when he was a child has a high conversion factor enabling him to turn the bicycle into the ability to move around efficiently, whereas a person with a physical impairment or someone who was never taught to ride a bike has a very low conversion factor. The conversion factors thus represent how much functioning one can get out of a good or service; in our example, how much mobility the person can get out of a bicycle.

There are several different types of conversion factors, and the conversion factors discussed are often categorized into three groups (Robeyns 2005: 99). All conversion factors influence how a person can be or is free to convert the characteristics of the resources into a functioning, yet the sources of these factors may differ. Personal conversion factors are internal to the person, such as metabolism, physical condition, sex, reading skills, or intelligence. If a person is disabled, is in bad physical condition, or has never learned to cycle, then the bike will be of limited help in enabling the functioning of mobility. Social conversion factors are factors from the society in which one lives, such as public policies, social norms, practices that unfairly discriminate, societal hierarchies, or power relations related to class, gender, race, or caste. Environmental conversion factors emerge from the physical or built environment in which a person lives. Among aspects of one's geographical location are climate, pollution, the proneness to earthquakes, and the presence or absence of seas and oceans. Among aspects of the built environment are the stability of buildings, roads, and bridges, and the means of transportation and communication. Take the example of the bicycle. How much a bicycle contributes to a person's mobility depends on that person's physical condition (a personal conversion factor), the social mores including whether women are socially allowed to ride a bicycle (a social conversion factor), and the available of decent roads or bike paths (an environmental conversion factor).

The three types of conversion factors all stress that it is not sufficient to know the resources a person owns or can use in order to be able to assess the well-being that he or she has achieved or could achieve; rather, we need to know much more about the person and the circumstances in which he or she is living. Sen uses “capability” not to refer exclusively to a person's abilities or other internal powers but to refer to an opportunity made feasible, and constrained by, both internal (personal) and external (social and environmental) conversion factors (Crocker 2008: 171–2; Robeyns 2005: 99).")
  argu2.arguments << a2

  a1.argumentation = argu2


end