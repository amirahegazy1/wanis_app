/// Abstract interface for generating therapeutic stories.
///
/// This allows swapping the local implementation with a cloud-based
/// AI-powered generator (e.g. Google Generative AI) in the future.
abstract class StoryGenerator {
  /// Generate a therapeutic story for the given [emotion].
  Future<TherapeuticStory> generateStory(String emotion);
}

/// A therapeutic story designed to help autistic children understand emotions.
class TherapeuticStory {
  final String title;
  final String body;
  final String emotion;
  final String emoji;
  final String moralLesson;

  const TherapeuticStory({
    required this.title,
    required this.body,
    required this.emotion,
    required this.emoji,
    required this.moralLesson,
  });
}

/// Local implementation of [StoryGenerator] using predefined Arabic stories.
///
/// Each of the 8 emotions has multiple stories that are randomly selected.
/// To integrate Google Generative AI in the future, create a new class that
/// implements [StoryGenerator] and swap this implementation.
class LocalTherapeuticStoryService implements StoryGenerator {
  static final Map<String, List<TherapeuticStory>> _stories = {
    'Neutral': [
      const TherapeuticStory(
        title: 'يوم ونيس الهادئ 🌤️',
        body:
            'في يوم جميل، قرر ونيس إنه يتمشى في الحديقة. الجو كان لطيف والشمس بتلمع. '
            'ونيس قعد تحت شجرة كبيرة وبدأ يسمع صوت العصافير. '
            'حس إنه مرتاح ومش محتاج يعمل أي حاجة غير إنه يستمتع باللحظة دي. '
            'بعدين قابل صاحبه نور، وقعدوا يرسموا مع بعض في السكتش بوك.\n\n'
            'ونيس اتعلم إن مش لازم نكون فرحانين أوي أو زعلانين أوي... '
            'ساعات بنكون كويسين وهاديين وده كمان شعور حلو! 💚',
        emotion: 'Neutral',
        emoji: '😐',
        moralLesson: 'الهدوء والسكينة شعور جميل، استمتع بيه!',
      ),
      const TherapeuticStory(
        title: 'ونيس والسلحفاة الحكيمة 🐢',
        body:
            'ونيس كان قاعد على الشاطئ لوحده، مش فرحان ومش زعلان. '
            'فجأة لقى سلحفاة كبيرة بتمشي ببطء. ونيس سألها: "ليه بتمشي ببطء كده؟" '
            'السلحفاة ابتسمت وقالت: "عشان أقدر أشوف كل حاجة حلوة حواليا." '
            'ونيس بص حواليه ولقى صدف ملون، ورمل ناعم، وموج هادي.\n\n'
            'ونيس فهم إن لما بنكون هاديين، بنقدر نلاحظ حاجات حلوة كتير حوالينا! 🌊',
        emotion: 'Neutral',
        emoji: '😐',
        moralLesson: 'الهدوء بيساعدنا نلاحظ الحاجات الحلوة اللي حوالينا.',
      ),
    ],
    'Happiness': [
      const TherapeuticStory(
        title: 'ونيس وحفلة الألوان 🎨',
        body:
            'ونيس صحي الصبح وهو فرحان أوي! حس إن قلبه مليان بالألوان. '
            'راح المدرسة وقرر يعمل حاجة حلوة لأصحابه. '
            'رسم لكل واحد فيهم صورة وكتب فيها كلمة حلوة. '
            'لما أصحابه شافوا الرسومات، فرحوا أوي وضحكوا مع بعض.\n\n'
            'ونيس اتعلم إن الفرحة لما بنشاركها مع الناس اللي بنحبهم، بتكبر وبتزيد! '
            'والابتسامة بتنتقل من واحد للتاني زي السحر! ✨',
        emotion: 'Happiness',
        emoji: '😄',
        moralLesson: 'الفرحة بتزيد لما بنشاركها مع اللي بنحبهم!',
      ),
      const TherapeuticStory(
        title: 'ونيس والفراشة الذهبية 🦋',
        body:
            'ونيس كان بيلعب في الحديقة، وفجأة شاف فراشة ذهبية جميلة أوي. '
            'الفراشة حطت على إيده وونيس حس بسعادة كبيرة. '
            'جري يقول لماما وبابا عن الفراشة، وهم فرحوا معاه. '
            'بعدين رسم الفراشة في كراسته عشان يفتكر اللحظة الحلوة دي.\n\n'
            'ونيس فهم إن اللحظات الحلوة الصغيرة ممكن تفرحنا فرحة كبيرة! 🌟',
        emotion: 'Happiness',
        emoji: '😄',
        moralLesson: 'اللحظات الصغيرة الحلوة هي أجمل هدية!',
      ),
    ],
    'Surprise': [
      const TherapeuticStory(
        title: 'ونيس والصندوق السحري 🎁',
        body:
            'ونيس رجع البيت من المدرسة ولقى صندوق كبير مستنيه! '
            'اتفاجئ أوي ومكنش عارف جواه إيه. فتح الصندوق بالراحة... '
            'ولقى جواه لعبة جديدة من جدو! ونيس كان مش مستني الهدية دي خالص. '
            'قلبه دق بسرعة من المفاجأة والفرحة.\n\n'
            'ونيس اتعلم إن المفاجآت ممكن تكون حلوة أوي! '
            'ومش لازم نخاف من الحاجات اللي مش متوقعينها، ساعات بتكون أحلى من اللي نتمنيناها! 🎉',
        emotion: 'Surprise',
        emoji: '😲',
        moralLesson: 'المفاجآت ممكن تكون حلوة، مش لازم نخاف منها!',
      ),
    ],
    'Sadness': [
      const TherapeuticStory(
        title: 'ونيس والمطرة الحنونة 🌧️',
        body:
            'ونيس كان حاسس بالزعل النهارده. عينيه كانت فيها دموع. '
            'بص من الشباك ولقى المطر بينزل برا. ماما جت قعدت جنبه وحضنته. '
            'قالتله: "عارف يا ونيس؟ حتى السما بتعيط ساعات، وبعد المطر بيطلع قوس قزح جميل." '
            'ونيس ابتسم وقال: "يعني الزعل مش هيفضل؟" '
            'ماما قالتله: "أكيد يا حبيبي، كل شعور وله وقته."\n\n'
            'ونيس فهم إن الزعل عادي وكلنا بنحس بيه. المهم إننا نتكلم عنه ومنخبيهوش. '
            'والحضن من حد بيحبنا بيخلينا أحسن! 💙',
        emotion: 'Sadness',
        emoji: '😢',
        moralLesson: 'الزعل عادي، والكلام عنه مع حد بيحبنا بيريحنا.',
      ),
      const TherapeuticStory(
        title: 'ونيس وشجرة الأماني 🌳',
        body:
            'ونيس كان زعلان عشان صاحبه سافر وهيوحشه. '
            'تيتة قالتله: "تعالى معايا يا ونيس." وأخدته لشجرة كبيرة في الجنينة. '
            'قالتله: "دي شجرة الأماني. لما تحس بالزعل، قول للشجرة اللي جواك." '
            'ونيس قال: "يا شجرة، أنا وحشني صاحبي." '
            'الهوا هز أوراق الشجرة كأنها بترد عليه.\n\n'
            'ونيس حس إنه أحسن. مش لازم الزعل يروح فوراً، بس لما بنعبر عن مشاعرنا بنحس براحة. 🍃',
        emotion: 'Sadness',
        emoji: '😢',
        moralLesson: 'التعبير عن مشاعرنا بيريحنا حتى لو الزعل مراحش خالص.',
      ),
    ],
    'Anger': [
      const TherapeuticStory(
        title: 'ونيس والبركان الصغير 🌋',
        body:
            'ونيس كان زعلان أوي النهارده! حس إن جواه بركان هيولّع! '
            'أخوه كسر لعبته المفضلة. ونيس كان عايز يصرخ ويزعق. '
            'بس تيتة جت وقالتله: "يا ونيس، تعالى نتنفس مع بعض." '
            'ونيس أخد نفس عميق... واحد... اتنين... تلاتة. '
            'حس إن البركان بدأ يهدأ شوية شوية.\n\n'
            'ونيس اتعلم إن الغضب شعور طبيعي، بس مش لازم نتصرف وإحنا غضبانين. '
            'لما ناخد نفس عميق ونستنى شوية، بنقدر نفكر أحسن! 🧘',
        emotion: 'Anger',
        emoji: '😡',
        moralLesson: 'لما نغضب، ناخد نفس عميق وبعدين نتكلم.',
      ),
      const TherapeuticStory(
        title: 'ونيس والوحش الأحمر 👹',
        body:
            'ونيس حس إن في وحش أحمر كبير قاعد جوا صدره! الوحش ده اسمه "غضب". '
            'ونيس كان عايز يكسر حاجات ويزعق. '
            'بس بابا قاله: "يا ونيس، الوحش ده مش عدوك. هو بيقولك إن في حاجة ضايقتك." '
            'ونيس فكر شوية وقال: "أنا زعلت عشان محدش سمعني." '
            'بابا حضنه وقاله: "أنا بسمعك يا حبيبي."  '
            'الوحش الأحمر بدأ يصغّر ويصغّر لحد ما بقى صغنن.\n\n'
            'ونيس فهم إن الغضب بيصغّر لما حد يسمعنا ونقول اللي جوانا. 💪',
        emotion: 'Anger',
        emoji: '😡',
        moralLesson: 'الغضب بيروح لما حد يسمعنا ونعبّر عن اللي جوانا.',
      ),
    ],
    'Disgust': [
      const TherapeuticStory(
        title: 'ونيس والأكل الغريب 🥦',
        body:
            'ونيس راح عند صاحبه في بيته، وأم صاحبه عملت أكل مختلف عن اللي ونيس متعود عليه. '
            'ونيس بص للأكل وحس إنه مش عايز ياكله. وشه اتغير وقال: "إيه ده!" '
            'بس صاحبه قاله: "جرب كدة لقمة صغيرة بس!" '
            'ونيس جرب لقمة صغيرة أوي... ولقى الطعم مش وحش! '
            'مش أحسن أكل في الدنيا بس مش وحش.\n\n'
            'ونيس اتعلم إن أوقات بنحس إن حاجات غريبة أو مش حلوة، '
            'بس لما بنجرب بالراحة وبخطوات صغيرة، ممكن نكتشف إنها كويسة! 🌟',
        emotion: 'Disgust',
        emoji: '🤢',
        moralLesson: 'مش كل حاجة مختلفة وحشة، جرب بالراحة!',
      ),
    ],
    'Fear': [
      const TherapeuticStory(
        title: 'ونيس والضلمة 🌙',
        body:
            'ونيس كان خايف من الضلمة. كل ما الأنوار تطفي، كان بيتغطى بالبطانية ويقفل عينيه. '
            'ماما جابتله كشاف صغير وقالتله: "ده كشاف الشجاعة يا ونيس!" '
            'ونيس ولّع الكشاف وبص في الأوضة. لقى كل حاجة زي ما هي! '
            'التيدي بير بتاعه قاعد مستنيه، والكتب على الرف.\n\n'
            'ونيس فهم إن الخوف ساعات بيكبّر الحاجات في دماغنا، '
            'بس لما بنواجه خوفنا خطوة خطوة، بنلاقي إن الموضوع مش مخيف أوي. '
            'وممكن نطلب مساعدة من حد بيحبنا لحد ما نحس بالأمان! 🔦',
        emotion: 'Fear',
        emoji: '😨',
        moralLesson: 'الخوف طبيعي، ولما نواجهه خطوة خطوة بنبقى شجعان!',
      ),
      const TherapeuticStory(
        title: 'ونيس والكلب الكبير 🐕',
        body:
            'ونيس شاف كلب كبير في الشارع وخاف أوي! قلبه دق بسرعة وعينيه كبرت. '
            'بابا مسك إيده وقاله: "ده كلب لطيف يا ونيس، بس لو خايف مش لازم تقرب منه." '
            'ونيس وقف بعيد وبص على الكلب. لقاه بيهز ديله ومبيعملش حاجة. '
            'بعد شوية حس إنه أهدى. '
            'بابا قاله: "شوفت؟ خوفك كان أكبر من الحاجة نفسها."\n\n'
            'ونيس اتعلم إن من حقه يخاف، وإن الخوف بيحمينا أوقات. '
            'بس المهم إننا مننسكتش ونتكلم عن خوفنا. 🤗',
        emotion: 'Fear',
        emoji: '😨',
        moralLesson: 'الخوف بيحمينا لكن لازم نتكلم عنه مع حد بيحبنا.',
      ),
    ],
    'Contempt': [
      const TherapeuticStory(
        title: 'ونيس والرسمة المختلفة 🎨',
        body:
            'في حصة الرسم، ونيس شاف رسمة صاحبه وحس إنها مش حلوة. حس جواه إنه أحسن. '
            'بس المس شافت رسمة صاحبه وقالت: "دي رسمة مميزة أوي!" '
            'ونيس استغرب. فالمس قالتله: "يا ونيس، كل واحد فينا مختلف وبيعمل حاجات بطريقته. '
            'مفيش رسمة غلط ومفيش رسمة صح، كل رسمة فيها حاجة حلوة."\n\n'
            'ونيس بص لرسمة صاحبه تاني ولقى فيها ألوان حلوة فعلاً! '
            'فهم إن كلنا مختلفين وده اللي بيخلي الدنيا حلوة ومليانة ألوان. 🌈',
        emotion: 'Contempt',
        emoji: '😏',
        moralLesson: 'كل واحد مميز بطريقته، والاختلاف حاجة جميلة!',
      ),
    ],
  };

  @override
  Future<TherapeuticStory> generateStory(String emotion) async {
    // Simulate a short delay as if generating the story
    await Future.delayed(const Duration(milliseconds: 800));

    final stories = _stories[emotion];
    if (stories == null || stories.isEmpty) {
      // Fallback if no story found for this emotion
      return const TherapeuticStory(
        title: 'قصة ونيس 📖',
        body: 'ونيس بيقولك إن كل مشاعرك مهمة ومفيش شعور غلط! '
            'المهم إننا نتكلم عن اللي جوانا ونلاقي حد يسمعنا. '
            'أنت بطل يا صحبي! 💪',
        emotion: 'Unknown',
        emoji: '📖',
        moralLesson: 'كل مشاعرك مهمة، عبّر عنها!',
      );
    }

    // Pick a random story from the available ones
    final random = stories.length == 1 ? 0 : DateTime.now().millisecondsSinceEpoch % stories.length;
    return stories[random];
  }

  /// Get the Arabic name & emoji for an emotion label.
  static ({String name, String emoji}) getEmotionArabic(String emotion) {
    switch (emotion) {
      case 'Neutral':
        return (name: 'طبيعي', emoji: '😐');
      case 'Happiness':
        return (name: 'سعيد', emoji: '😄');
      case 'Surprise':
        return (name: 'متفاجئ', emoji: '😲');
      case 'Sadness':
        return (name: 'حزين', emoji: '😢');
      case 'Anger':
        return (name: 'غضبان', emoji: '😡');
      case 'Disgust':
        return (name: 'مشمئز', emoji: '🤢');
      case 'Fear':
        return (name: 'خايف', emoji: '😨');
      case 'Contempt':
        return (name: 'مستهزئ', emoji: '😏');
      default:
        return (name: emotion, emoji: '😐');
    }
  }
}
