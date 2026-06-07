class SurveyQuestion {
  final int id;
  final String questionText;
  final String illustrationPath;

  const SurveyQuestion({
    required this.id,
    required this.questionText,
    required this.illustrationPath,
  });
}

// 12 Survey Questions based on the Figma design
final List<SurveyQuestion> surveyQuestions = [
  const SurveyQuestion(
    id: 1,
    questionText: 'هل يجد صعوبة في التعبير عن مشاعره؟', // Placeholder for missing Q1 text
    illustrationPath: 'assets/images/survey_q1.png', 
  ),
  const SurveyQuestion(
    id: 2,
    questionText: 'هل يجد صعوبة في الانتقال بين الأنشطة؟',
    illustrationPath: 'assets/images/survey_q2.png',
  ),
  const SurveyQuestion(
    id: 3,
    questionText: 'هل يلاحظ الألوان والأشكال؟',
    illustrationPath: 'assets/images/survey_q3.png',
  ),
  const SurveyQuestion(
    id: 4,
    questionText: 'هل يتجنب المهام التي تحتاج تركيز؟',
    illustrationPath: 'assets/images/survey_q4.png',
  ),
  const SurveyQuestion(
    id: 5,
    questionText: 'هل يخطئ بسبب التسرع؟',
    illustrationPath: 'assets/images/survey_q5.png',
  ),
  const SurveyQuestion(
    id: 6,
    questionText: 'هل يكمل النشاط حتى النهاية؟',
    illustrationPath: 'assets/images/survey_q6.png',
  ),
  const SurveyQuestion(
    id: 7,
    questionText: 'هل يقلد حركات بسيطة؟',
    illustrationPath: 'assets/images/survey_q7.png',
  ),
  const SurveyQuestion(
    id: 8,
    questionText: 'هل يستخدم الأدوات بشكل صحيح؟',
    illustrationPath: 'assets/images/survey_q8.png',
  ),
  const SurveyQuestion(
    id: 9,
    questionText: 'هل يستجيب عند مناداته؟',
    illustrationPath: 'assets/images/survey_q9.png',
  ),
  const SurveyQuestion(
    id: 10,
    questionText: 'هل يتفاعل مع الأطفال الآخرين؟', // Placeholder
    illustrationPath: 'assets/images/survey_q10.png',
  ),
  const SurveyQuestion(
    id: 11,
    questionText: 'هل يعاني من فرط الحركة؟', // Placeholder
    illustrationPath: 'assets/images/survey_q11.png',
  ),
  const SurveyQuestion(
    id: 12,
    questionText: 'هل تلاحظ تطوراً في مهاراته الحركية؟', // Placeholder
    illustrationPath: 'assets/images/survey_q12.png',
  ),
];
