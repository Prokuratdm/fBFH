// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'fBFH';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get usernameLabel => 'Username';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get loginError => 'Login Error';

  @override
  String get loginNetworkError => 'Network error. Check your connection.';

  @override
  String welcome(String username) {
    return 'Hello, $username!';
  }

  @override
  String get logoutButton => 'Sign Out';

  @override
  String get menuDashboard => 'Dashboard';

  @override
  String get menuClubs => 'Clubs';

  @override
  String get menuMyClub => 'My Club';

  @override
  String get menuUsers => 'Users';

  @override
  String get menuTeams => 'Teams';

  @override
  String get menuMyTeams => 'My Teams';

  @override
  String get menuChildren => 'Children';

  @override
  String get menuTrainings => 'Trainings';

  @override
  String get menuLocations => 'Locations';

  @override
  String get menuInventory => 'Inventory';

  @override
  String get menuExercises => 'Exercises';

  @override
  String get menuStandards => 'Standards';

  @override
  String get menuTemplates => 'Template Trainings';

  @override
  String get menuPrograms => 'Programs';

  @override
  String get inDevelopment => 'In Development';

  @override
  String get fieldRequired => 'Required field';

  @override
  String get clubsTitle => 'Clubs';

  @override
  String get clubsCreateButton => 'Create New Club';

  @override
  String get clubNameLabel => 'Name';

  @override
  String get clubAddressLabel => 'Address';

  @override
  String get clubDescriptionLabel => 'Description';

  @override
  String get clubLogoLabel => 'Logo';

  @override
  String get clubCreateDialogTitle => 'New Club';

  @override
  String get clubLogoErrorSize => 'Logo file must not exceed 200 KB';

  @override
  String get clubLogoErrorDimensions =>
      'Logo must be no larger than 200×200 pixels';

  @override
  String get clubLogoSelectFile => 'Select File';

  @override
  String get clubCreate => 'Create';

  @override
  String get clubNoLogo => 'No logo';

  @override
  String get clubRetry => 'Retry';

  @override
  String get clubLogoUploadError =>
      'Logo upload failed. You can add it when editing the club.';

  @override
  String get usersTitle => 'Users';

  @override
  String get usersCreateButton => 'Create User';

  @override
  String get userCreated => 'User created';

  @override
  String get userDetailTitle => 'User Details';

  @override
  String get userUsernameLabel => 'Username';

  @override
  String get userPasswordLabel => 'Password';

  @override
  String get userEmailLabel => 'Email';

  @override
  String get userRolesLabel => 'Roles';

  @override
  String get userClubLabel => 'Club';

  @override
  String get userChangePassword => 'Change Password';

  @override
  String get newPasswordLabel => 'New Password';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get roleAdmin => 'Admin';

  @override
  String get roleMethodist => 'Methodist';

  @override
  String get roleCoach => 'Coach';

  @override
  String get roleMainCoach => 'Head Coach';

  @override
  String get roleClub => 'Club';

  @override
  String get roleClubMethodist => 'Club Methodist';

  @override
  String get filterRole => 'Role';

  @override
  String get filterClub => 'Club';

  @override
  String get filterUsername => 'Username';

  @override
  String get allRoles => 'All roles';

  @override
  String get allClubs => 'All clubs';

  @override
  String get noClub => 'No club';

  @override
  String get locationsTitle => 'Locations';

  @override
  String get locationsCreateButton => 'Create Location';

  @override
  String get locationNameLabel => 'Name';

  @override
  String get locationCreateDialogTitle => 'New Location';

  @override
  String get locationCreate => 'Create';

  @override
  String get locationCreated => 'Location created';

  @override
  String get locationsEmpty => 'No locations yet';

  @override
  String get locationsNoClub =>
      'User is not assigned to a club. Locations are unavailable.';

  @override
  String get inventoryTitle => 'Inventory';

  @override
  String get inventoryCreateButton => 'Create Inventory';

  @override
  String get inventoryNameLabel => 'Name';

  @override
  String get inventoryClubLabel => 'Club';

  @override
  String get inventoryCreateDialogTitle => 'New Inventory';

  @override
  String get inventoryCreate => 'Create';

  @override
  String get inventoryCreated => 'Inventory created';

  @override
  String get inventoryEmpty => 'No inventory yet';

  @override
  String get inventoryNoClub => 'No clubs available to create inventory.';
}
