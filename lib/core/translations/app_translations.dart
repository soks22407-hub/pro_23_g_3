import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      // Auth
      'login': 'Login',
      'logging in...': 'Logging in...',
      'username': 'Username',
      'password': 'Password',
      'login_success': 'Login successful',
      'login_failed': 'Username or password is incorrect',
      'app_name': 'GetX Basic',
      'login_welcome': 'Welcome Back',
      'login_subtitle': 'Sign in to your account',
      'no_account_register': "Don't have an account? Register",

      //register
      'create_account': 'Create your account',
      'nickname_optional': 'Nickname (optional)',
      'password_condition': "At least 8 characters with an uppercase, a lowercase, a number and a symbol.",
      'registering...': "Registering...",
      'register': "Register",


      //time
      'just_now': 'Just now',
      'minutes_ago': 'm ago',
      'hours_ago': 'h ago',
      'days_ago': 'd ago',
      'months_ago': 'months ago',
      'years_ago': 'years ago',


      // Bottom nav
      'home': 'Home',
      'post': 'Post',
      'user': 'User',
      'setting': 'Setting',

      // Drawer / Settings
      'users': 'Users',
      'new user': 'New user',
      'language': 'Language',
      'connection': 'Connection',
      'online': 'online',
      'offline': 'Offline',
      'logout': 'Logout',
      'signed_in_as': 'Signed in as',
      'your_account': 'YOUR ACCOUNT',
      'preferences': 'PREFERENCES',
      'about': 'ABOUT',
      'edit_profile': 'Edit profile',
      'edit_profile_subtitle': 'Update your name and photo',
      'switch_language': 'Switch between Khmer and English',
      'version': 'Version',
      'logout_confirm': 'Are you sure you want to logout?',
      'cancel': 'Cancel',

      // Posts
      'posts': 'Posts',
      'new_post': 'New post',
      'search_by_title': 'Search by title',
      'no_posts_found': 'No posts found',
      'draft': 'Draft',
      'edit': 'Edit',
      'delete': 'Delete',
      'public': 'Public',
      'unpublic': 'Unpublic',
      'delete_post_title': 'Delete Post',
      'delete_post_confirm': 'Are you sure you want to delete this post?',
      'shown_of': 'of',
      'shown_suffix': 'shown',
      'shown_count': '@shown of @total shown',
      'title': 'Title',
      'enter_post_title': 'Enter post title',
      'content': 'Content',
      'write_your_post': 'Write your post...',
      'image': 'Image',
      'tap_to_select_image': 'Tap to select image',
      'remove_image': 'Remove image',
      'visibility': 'Visibility',
      'published': 'Published',
      'published_subtitle': 'Everyone can see this post',
      'unpublished_subtitle': 'Only you can see this post',
      'create_post': 'Create post',


      // Users
      'search_by_username': 'Search by username',
      'no_users_found': 'No users found',
      'disabled': 'Disabled',
      'enable': 'Enable',
      'disable': 'Disable',
      'delete_user_title': 'Delete User',
      'delete_user_confirm': 'Are you sure you want to delete this user?',
      'create': 'Created',

      // User Detail
      'user_detail': 'User detail',
      'enabled': 'Enabled',
      'id': 'ID',
      'nickname': 'Nickname',
      'image_file': 'Image file',
      'created': 'Created',
      'updated': 'Updated',

      //User create
      'new_user': 'New user',
      'photo_upload_note': 'Photo uploads after the user is created',
      'username_email': 'Username (email)',
      'nickname_hint': 'The server generates one if you leave this blank',
      'creating': 'Creating...',
      'create_user': 'Create user',

      //User Edit
      'edit_user': 'Edit user',
      'tap_to_replace_photo': 'Tap to replace the photo',
      'enter_nickname': 'Enter a nickname',
      'updating': 'Updating...',
      'update': 'Update',

      // Home
      'latest_posts': 'Latest Posts',
      'no_posts_yet': 'No posts yet',
      'upload_a_photo': 'Upload a photo',
    },

    'km_KH': {
      // Auth
      'logging in...': 'កំពុងចូលគណនី',
      'login': 'ចូលគណនី',
      'username': 'ឈ្មោះអ្នកប្រើប្រាស់',
      'password': 'ពាក្យសម្ងាត់',
      'login_success': 'ចូលគណនីបានជោគជ័យ',
      'login_failed': 'ឈ្មោះអ្នកប្រើប្រាស់ ឬពាក្យសម្ងាត់មិនត្រឹមត្រូវ',
      'app_name': 'GetX មូលដ្ឋាន',
      'login_welcome': 'សូមស្វាគមន៍ការត្រឡប់មកវិញ',
      'login_subtitle': 'ចូលទៅកាន់គណនីរបស់អ្នក',
      'no_account_register': 'មិនមានគណនីមែនទេ? ចុះឈ្មោះ',
      //register
      'create_account': 'បង្កើតគណនីរបស់អ្នក',
      'nickname_optional': 'ឈ្មោះហៅក្រៅ (មិនចាំបាច់)',
      'password_condition': 'យ៉ាងតិច ៨ តួអក្សរ ដោយមានអក្សរធំ អក្សរតូច លេខ និង សញ្ញាពិសេស។',
      'registering...': "កំពុងចុះឈ្មោះ...",
      'register': "ចុះឈ្មោះ",


      //time
      'just_now': 'អម្បាញ់មិញ',
      'minutes_ago': 'នាទីមុន',
      'hours_ago': 'ម៉ោងមុន',
      'days_ago': 'ថ្ងៃមុន',
      'months_ago': 'ខែមុន',
      'years_ago': 'ឆ្នាំមុន',

      // Bottom nav
      'home': 'ទំព័រដើម',
      'post': 'អត្ថបទ',
      'user': 'អ្នកប្រើប្រាស់',
      'setting': 'ការកំណត់',

      // Drawer / Settings
      'users': 'អ្នកប្រើប្រាស់',
      'new user': 'អ្នកប្រើប្រាស់ថ្មី',
      'language': 'ភាសា',
      'connection': 'ការតភ្ជាប់',
      'online': 'មានអ៊ីនធឺណែត',
      'offline': 'គ្មានអ៊ីនធឺណិត',
      'logout': 'ចាកចេញ',
      'signed_in_as': 'បានចូលក្នុងនាម',
      'your_account': 'គណនីរបស់អ្នក',
      'preferences': 'ចំណូលចិត្ត',
      'about': 'អំពី',
      'edit_profile': 'កែសម្រួលប្រវត្តិរូប',
      'edit_profile_subtitle': 'ធ្វើបច្ចុប្បន្នភាពឈ្មោះ និងរូបភាព',
      'switch_language': 'ប្តូររវាងភាសាខ្មែរ និងអង់គ្លេស',
      'version': 'កំណែ',
      'logout_confirm': 'តើអ្នកប្រាកដថាចង់ចាកចេញមែនទេ?',
      'cancel': 'បោះបង់',

      // Posts
      'posts': 'អត្ថបទ',
      'new_post': 'អត្ថបទថ្មី',
      'search_by_title': 'ស្វែងរកតាមចំណងជើង',
      'no_posts_found': 'រកមិនឃើញអត្ថបទ',
      'draft': 'សេចក្តីព្រាង',
      'edit': 'កែសម្រួល',
      'delete': 'លុប',
      'public': 'ផ្សាយ',
      'unpublic': 'ដកការផ្សាយ',
      'delete_post_title': 'លុបអត្ថបទ',
      'delete_post_confirm': 'តើអ្នកប្រាកដថាចង់លុបអត្ថបទនេះមែនទេ?',
      'shown_of': 'នៃ',
      'shown_suffix': 'បង្ហាញ',
      'shown_count': 'បង្ហាញ @shown ក្នុងចំណោម @total',
      'title': 'ចំណងជើង',
      'enter_post_title': 'បញ្ចូលចំណងជើងអត្ថបទ',
      'content': 'មាតិកា',
      'write_your_post': 'សរសេរអ្វីមួយ...',
      'image': 'រូបភាព',
      'tap_to_select_image': 'ចុចដើម្បីជ្រើសរើសរូបភាព',
      'remove_image': 'លុបរូបភាព',
      'visibility': 'ភាពមើលឃើញ',
      'published': 'បានផ្សាយ',
      'published_subtitle': 'មើលឃើញដោយអ្នកទាំងអស់គ្នា',
      'unpublished_subtitle': 'មើលឃើញតែអ្នកប៉ុណ្ណោះ',
      'create_post': 'បង្កើតអត្ថបទ',

      // Users
      'search_by_username': 'ស្វែងរកតាមឈ្មោះអ្នកប្រើប្រាស់',
      'no_users_found': 'រកមិនឃើញអ្នកប្រើប្រាស់',
      'disabled': 'បិទដំណើរការ',
      'enable': 'បើកដំណើរការ',
      'disable': 'បិទដំណើរការ',
      'delete_user_title': 'លុបអ្នកប្រើប្រាស់',
      'delete_user_confirm': 'តើអ្នកប្រាកដថាចង់លុបអ្នកប្រើប្រាស់នេះមែនទេ?',
      'create': 'បង្កើត',

      // User Detail
      'user_detail': 'ព័ត៌មានអ្នកប្រើប្រាស់',
      'enabled': 'សកម្ម',
      'id': 'លេខសម្គាល់',
      'nickname': 'ឈ្មោះហៅក្រៅ',
      'image_file': 'ឯកសាររូបភាព',
      'created': 'បានបង្កើត',
      'updated': 'ថ្ងៃកែប្រែ',

      //User Create
      'new_user': 'អ្នកប្រើប្រាស់ថ្មី',
      'photo_upload_note': 'រូបភាពនឹងផ្ទុកបន្ទាប់ពីបង្កើតអ្នកប្រើប្រាស់',
      'username_email': 'ឈ្មោះអ្នកប្រើប្រាស់ (អ៊ីមែល)',
      'nickname_hint': 'ប្រសិនបើទុកឲ្យទទេ ម៉ាស៊ីននឹងបង្កើតដោយស្វ័យប្រវត្តិ',
      'creating': 'កំពុងបង្កើត...',
      'create_user': 'បង្កើតអ្នកប្រើប្រាស់',

      //User Edit
      'edit_user': 'កែប្រែអ្នកប្រើប្រាស់',
      'tap_to_replace_photo': 'ចុចដើម្បីប្តូររូបភាព',
      'enter_nickname': 'បញ្ចូលឈ្មោះហៅក្រៅ',
      'updating': 'កំពុងធ្វើបច្ចុប្បន្នភាព...',
      'update': 'កែសម្រួល',

      // Home
      'latest_posts': 'អត្ថបទថ្មីៗ',
      'no_posts_yet': 'មិនទាន់មានអត្ថបទ',
      'upload_a_photo': 'ផ្ទុករូបភាព',
    },
  };
}
