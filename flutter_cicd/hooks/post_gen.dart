import 'package:mason/mason.dart';

void run(HookContext context) {
  final appName = context.vars['app_name'] as String;
  final platform = context.vars['platform'] as String;
  final deployTarget = context.vars['deploy_target'] as String;

  context.logger.success(
    '✅ CI/CD workflow files generated successfully for "$appName"!',
  );

  context.logger.info('');
  context.logger.info('📁 Files created:');
  context.logger.info('   .github/workflows/build.yml');
  context.logger.info('   .github/workflows/deploy.yml');
  context.logger.info('');
  context.logger.info('🔧 Configuration:');
  context.logger.info('   Platform : $platform');
  context.logger.info('   Deploy to: $deployTarget');
  context.logger.info('');
  context.logger.info('📖 Next steps:');
  context.logger.info('   1. Add required GitHub Secrets (see README.md)');
  context.logger.info('   2. git add .github/ && git commit -m "chore: add CI/CD workflows"');
  context.logger.info('   3. git push — your pipeline is live! 🚀');
  context.logger.info('');
}
