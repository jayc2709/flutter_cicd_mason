import 'package:mason/mason.dart';

void run(HookContext context) {
  final platform = context.vars['platform'] as String;
  final androidBuildType = context.vars['android_build_type'] as String;
  final iosBuildMethod = context.vars['ios_build_method'] as String;
  final deployTarget = context.vars['deploy_target'] as String;

  // Platform Booleans
  context.vars['isAndroid'] = platform == 'android' || platform == 'both';
  context.vars['isIos'] = platform == 'ios' || platform == 'both';

  // Android Logic
  context.vars['buildApk'] = androidBuildType == 'apk' || androidBuildType == 'both';
  context.vars['buildAppBundle'] = androidBuildType == 'appbundle' || androidBuildType == 'both';

  // iOS Logic
  context.vars['isSimulator'] = iosBuildMethod == 'simulator';
  context.vars['isDeviceUnsigned'] = iosBuildMethod == 'device_unsigned';
  context.vars['isFastlaneIos'] = iosBuildMethod == 'fastlane_placeholder';

  // Deploy Logic
  context.vars['deployToFirebase'] = deployTarget == 'firebase';
  context.vars['deployToPlayStore'] = deployTarget == 'playstore';
  context.vars['deployToAppStore'] = deployTarget == 'appstore';

  // List Parsing
  context.vars['buildBranchList'] = _splitCsv(context.vars['build_branches'] as String);
  context.vars['deployBranchList'] = _splitCsv(context.vars['deploy_branches'] as String);
  context.vars['prTargetBranchList'] = _splitCsv(context.vars['pr_target_branches'] as String);
  
  if (context.vars['use_flavors'] == true) {
    context.vars['flavorIterable'] = _splitCsv(context.vars['flavor_list'] as String);
  }
}

List<Map<String, String>> _splitCsv(String? value) {
  if (value == null || value.isEmpty) return [];
  return value.split(',').map((e) => {'name': e.trim()}).toList();
}
}
