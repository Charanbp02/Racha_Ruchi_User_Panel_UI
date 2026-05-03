import 'package:get/get.dart';
import 'package:racharuchi/App/Models/Shorts_Model/shorts_models.dart';

class ShortsController extends GetxController {
  var shortsList = <ShortsModel>[].obs;
  var currentIndex = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadShorts();
  }

  void loadShorts() {
    isLoading.value = true;

    shortsList.value = [
      ShortsModel(
        id: '1',
        imageUrl:
            'https://youtu.be/WMMxpiQgmto?si=53L4bznER0cu7vsc',
        title: 'Chicken Biryani Recipe 🔥',
        caption:
            'Learn how to make perfect Hyderabadi Dum Biryani at home #Biryani #Food',
        likes: '125K',
        comments: '2.3K',
        shares: '5.2K',
        user: 'Chef Ramesh',
        userImage: 'https://randomuser.me/api/portraits/men/1.jpg',
      ),
      ShortsModel(
        id: '2',
        imageUrl:
            'https://youtu.be/WMMxpiQgmto?si=53L4bznER0cu7vsc',
        title: 'Paneer Butter Masala',
        caption:
            'Restaurant style creamy paneer butter masala in 20 mins #Paneer #Recipe',
        likes: '87K',
        comments: '1.2K',
        shares: '3.1K',
        user: 'Home Cooking',
        userImage: 'https://randomuser.me/api/portraits/women/2.jpg',
      ),
      ShortsModel(
        id: '3',
        imageUrl:
            'https://youtu.be/WMMxpiQgmto?si=53L4bznER0cu7vscc',
        title: 'Crispy Masala Dosa',
        caption:
            'Perfect crispy dosa with potato masala - Street style #Dosa #SouthIndian',
        likes: '256K',
        comments: '5.4K',
        shares: '12.1K',
        user: 'Street Food India',
        userImage: 'https://randomuser.me/api/portraits/men/3.jpg',
      ),
      ShortsModel(
        id: '4',
        imageUrl:
            'https://youtu.be/WMMxpiQgmto?si=53L4bznER0cu7vsc',
        title: 'Butter Chicken',
        caption:
            'Famous Punjabi butter chicken recipe - Perfect for parties #ButterChicken',
        likes: '425K',
        comments: '8.7K',
        shares: '18.3K',
        user: 'Royal Kitchen',
        userImage: 'https://randomuser.me/api/portraits/women/4.jpg',
      ),
      ShortsModel(
        id: '5',
        imageUrl:
            'https://youtu.be/WMMxpiQgmto?si=53L4bznER0cu7vsc',
        title: 'Chicken Tikka',
        caption:
            'Juicy and smoky chicken tikka - Perfect starter #ChickenTikka #BBQ',
        likes: '189K',
        comments: '3.2K',
        shares: '7.5K',
        user: 'Grill Master',
        userImage: 'https://randomuser.me/api/portraits/men/5.jpg',
      ),
    ];

    isLoading.value = false;
  }

  void likeVideo(int index) {
    shortsList[index].isLiked = !shortsList[index].isLiked;
    if (shortsList[index].isLiked) {
      int currentLikes = int.parse(shortsList[index].likes.replaceAll('K', ''));
      shortsList[index].likes = '${currentLikes + 1}K';
    } else {
      int currentLikes = int.parse(shortsList[index].likes.replaceAll('K', ''));
      shortsList[index].likes = '${currentLikes - 1}K';
    }
    shortsList.refresh();
  }

  void addComment(int index, String comment) {
    int currentComments = int.parse(
      shortsList[index].comments.replaceAll('K', ''),
    );
    shortsList[index].comments = '${currentComments + 1}K';
    shortsList.refresh();
  }

  void shareVideo(int index) {
    shortsList[index].shares =
        '${int.parse(shortsList[index].shares.replaceAll('K', '')) + 1}K';
    shortsList.refresh();
  }

  void changeIndex(int index) {
    currentIndex.value = index;
  }
}
