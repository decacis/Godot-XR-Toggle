# Godot XR Toggle

The Godot XR Toggle is a simple toggle to run with VR enabled or not, from the editor.

This repository also includes an example of a project that can run VR and non-VR, thought the main focus is the XR Toggle plugin.


## Installing

After downloading asset from the [GitHub releases page](https://github.com/decacis/godot_xr_toggle/releases), just place it into your project.

Once you put the files in your project, head on to the Project Settings -> Plugins and enable the plugin there:

![enable-plugin](./assets/screenshots/plugin_enable.png)

## Force toggle XR when exporting

You can force XR being enabled/disabled when exporting for certain platforms. This is useful because when you are in the editor, you could have the XR Toggle disabled, but when exporting for the Quest (android) you want to have OpenXR always enabled, so you can add the platform to the "Platforms Force Mode" section like this:

![plugin_settings](./assets/screenshots/plugin_settings.png)
