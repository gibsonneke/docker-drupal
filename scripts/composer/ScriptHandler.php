<?php

/**
 * @file
 * Contains \DrupalProject\composer\ScriptHandler.
 */

namespace DrupalProject\composer;

use Composer\Script\Event;
use Symfony\Component\Filesystem\Filesystem;

class ScriptHandler {

  public static function createRequiredFiles(Event $event) {
    $fs = new Filesystem();
    $root = static::getDrupalRoot(getcwd());

    $dirs = [
      'modules',
      'profiles',
      'themes',
    ];

    // Required for unit testing
    foreach ($dirs as $dir) {
      if (!$fs->exists($root . '/' . $dir)) {
        $fs->mkdir($root . '/' . $dir);
        $fs->touch($root . '/' . $dir . '/.gitkeep');
      }
    }

    // Prepare the settings.php file for installation
    self::copyFile('/sites/default/default.settings.php', '/sites/default/settings.php', $fs, $event);

    // Prepare the settings.local.php file for installation
    self::copyFile('/sites/example.settings.local.php', '/sites/default/settings.local.php', $fs, $event);

    // Prepare the services.yml file for installation
    self::copyFile('/sites/default/default.services.yml', '/sites/default/services.yml', $fs, $event);

    // Create the files directory with chmod 0777
    self::makeDirectory('/sites/default/files', $fs, $event);

    // Create the private directory with chmod 0777
    self::makeDirectory('/sites/default/private', $fs, $event);

    // Create the private/temp directory with chmod 0777
    self::makeDirectory('/sites/default/private/temp', $fs, $event);
  }

  /**
   * HELPERS
   */

  protected static function getDrupalRoot($project_root) {
    return $project_root . '/web';
  }

  protected static function copyFile($from, $to, $fs, Event $event) {
    $root = static::getDrupalRoot(getcwd());
    if (!$fs->exists($root . $to)) {
      $fs->copy($root . $from, $root . $to);
      $fs->chmod($root . $to, 0644);
      $event->getIO()->write("Create a $from file with chmod 0644");
    }
  }

  protected static function makeDirectory($path, $fs, Event $event) {
    $root = static::getDrupalRoot(getcwd());
    if (!$fs->exists($root . $path)) {
      $oldmask = umask(0);
      $fs->mkdir($root . $path, 0777);
      umask($oldmask);
      $event->getIO()->write("Create a $path directory with chmod 0777");
    }
  }
}
