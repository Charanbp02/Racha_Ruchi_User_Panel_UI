import 'package:get/get.dart';
import 'package:racharuchi/App/Models/About/about_model.dart';

class AboutController extends GetxController {
  final selectedLanguage = 'kannada'.obs;
  final aboutData = Rxn<AboutModel>();
  final isLoading = false.obs;

  final Map<String, Map<String, String>> translations = {
    'kannada': {
      'title': 'ರಚಾ ರುಚಿ ಬಗ್ಗೆ',
      'founders': 'ಚರಣ್ ಮತ್ತು ರಕ್ಷಿತಾ',
      'description':
          'ರಚಾ ರುಚಿ ಅನ್ನು ಚರಣ್ ಮತ್ತು ರಕ್ಷಿತಾ ಅವರು ಸೇರಿ ಸ್ಥಾಪಿಸಿದ್ದಾರೆ.\n\nಆಹಾರ, ಅಡುಗೆ ಮತ್ತು ಹೊಸ ಸೃಜನಾತ್ಮಕ ಆಲೋಚನೆಗಳ ಮೇಲಿನ ನಮ್ಮ ಆಸಕ್ತಿಯಿಂದ ಆರಂಭವಾದ ಈ ಪ್ರಯಾಣ, ಇಂದು ಆಹಾರ ಪ್ರಿಯರು ಪಾಕವಿಧಾನಗಳನ್ನು ಕಂಡುಹಿಡಿಯಲು, ತಮ್ಮ ಅಡುಗೆ ಅನುಭವಗಳನ್ನು ಹಂಚಿಕೊಳ್ಳಲು ಮತ್ತು ಒಂದೇ ಸಮುದಾಯದಲ್ಲಿ ಒಂದಾಗಲು ಸಹಾಯ ಮಾಡುವ ವೇದಿಕೆಯಾಗಿ ಬೆಳೆದಿದೆ.',
      'vision':
          'Spicy Business ಜೊತೆಗೆ, ಮನೆ ಅಡುಗೆಗಾರರು, ರೆಸಿಪಿ ಕ್ರಿಯೇಟರ್‌ಗಳು ಮತ್ತು ಆಹಾರಾಸಕ್ತರು ಕಲಿಯಲು, ಹಂಚಿಕೊಳ್ಳಲು ಮತ್ತು ಒಟ್ಟಿಗೆ ಬೆಳೆಯಲು ಒಂದು ವಿಶ್ವಾಸಾರ್ಹ ವೇದಿಕೆಯನ್ನು ನಿರ್ಮಿಸುವುದು ನಮ್ಮ ಉದ್ದೇಶ.',
      'mission':
          'ಪ್ರತಿ ಪಾಕವಿಧಾನದ ಹಿಂದೆ ಒಂದು ಕಥೆ ಇರುತ್ತದೆ ಮತ್ತು ಪ್ರತಿಯೊಬ್ಬ ಅಡುಗೆಗಾರನಲ್ಲೂ ವಿಶೇಷ ಪ್ರತಿಭೆ ಇರುತ್ತದೆ ಎಂದು ನಾವು ನಂಬಿದ್ದೇವೆ. ರಚಾ ರುಚಿಯ ಮೂಲಕ ಹೊಸ ರುಚಿಗಳನ್ನು ಅನ್ವೇಷಿಸಲು, ಮನೆಯ ಅಡುಗೆಯ ಸೌಂದರ್ಯವನ್ನು ಆಚರಿಸಲು ಮತ್ತು ಅಡುಗೆಯ ಮೇಲಿನ ಪ್ರೀತಿಯಿಂದ ಬಲವಾದ ಸಮುದಾಯವನ್ನು ನಿರ್ಮಿಸಲು ನಾವು ಆಶಿಸುತ್ತೇವೆ.',
      'tagline':
          '"ಆಹಾರದ ಮೇಲಿನ ಪ್ರೀತಿಯಿಂದ ನಿರ್ಮಿತ, ಆಹಾರ ಪ್ರಿಯರಿಗಾಗಿ ರೂಪಿತ." ❤️🍲',
    },
    'english': {
      'title': 'About Racha Ruchi',
      'founders': 'Charan & Rakshitha',
      'description':
          'Racha Ruchi was founded by Charan and Rakshitha.\n\nWhat started as our passion for food, cooking, and creative ideas has grown into a platform where food lovers can discover recipes, share their cooking experiences, and connect as one community.',
      'vision':
          'Along with Spicy Business, our vision is to build a trusted platform where home cooks, recipe creators, and food enthusiasts can learn, share, and grow together.',
      'mission':
          'We believe every recipe has a story and every cook has a unique talent. Through Racha Ruchi, we hope to explore new flavors, celebrate the beauty of home cooking, and build a strong community bound by the love of cooking.',
      'tagline': '"Built with love for food, designed for food lovers." ❤️🍲',
    },
    'hindi': {
      'title': 'रचा रुचि के बारे में',
      'founders': 'चरण और रक्षिता',
      'description':
          'रचा रुचि की स्थापना चरण और रक्षिता ने की थी।\n\nभोजन, खाना पकाने और रचनात्मक विचारों के प्रति हमारे जुनून के रूप में शुरू हुई यह यात्रा आज एक ऐसे मंच के रूप में विकसित हुई है जहाँ खाने के शौकीन व्यंजनों को खोज सकते हैं, अपने खाना पकाने के अनुभव साझा कर सकते हैं और एक समुदाय के रूप में जुड़ सकते हैं।',
      'vision':
          'स्पाइसी बिजनेस के साथ, हमारा उद्देश्य एक विश्वसनीय मंच बनाना है जहाँ घरेलू रसोइया, रेसिपी क्रिएटर और खाद्य उत्साही सीख सकें, साझा कर सकें और एक साथ बढ़ सकें।',
      'mission':
          'हम मानते हैं कि हर रेसिपी के पीछे एक कहानी होती है और हर रसोइए में एक विशेष प्रतिभा होती है। रचा रुचि के माध्यम से, हम नए स्वादों का पता लगाने, घरेलू खाना पकाने की सुंदरता का जश्न मनाने और खाना पकाने के प्यार से बंधे एक मजबूत समुदाय का निर्माण करने की आशा करते हैं।',
      'tagline':
          '"भोजन के प्रति प्रेम से निर्मित, भोजन प्रेमियों के लिए डिज़ाइन किया गया।" ❤️🍲',
    },
  };

  @override
  void onInit() {
    super.onInit();
    loadAboutData();
  }

  void loadAboutData() {
    isLoading.value = true;
    // Simulate loading delay
    Future.delayed(const Duration(milliseconds: 500), () {
      updateAboutData();
      isLoading.value = false;
    });
  }

  void updateAboutData() {
    final langData = translations[selectedLanguage.value]!;
    aboutData.value = AboutModel(
      title: langData['title']!,
      founders: langData['founders']!,
      description: langData['description']!,
      vision: langData['vision']!,
      mission: langData['mission']!,
      tagline: langData['tagline']!,
    );
  }

  void changeLanguage(String language) {
    selectedLanguage.value = language;
    updateAboutData();
  }

  String getCurrentLanguageName() {
    switch (selectedLanguage.value) {
      case 'kannada':
        return 'ಕನ್ನಡ';
      case 'english':
        return 'English';
      case 'hindi':
        return 'हिन्दी';
      default:
        return 'English';
    }
  }
}
