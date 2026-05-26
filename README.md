## GATO (Godot Accessibility TOolkit)

> Note: Project still in early development!

This is a collection of demos and plugins to help you make your games more accessible.

## Development notes

### Update Godot versions

When a new version of Godot is released and you want to update the project to run in that version, you should follow these steps/checks:

1. Update the project in Godot.
2. Update GUT to a version that is compatible with the new Godot version.
3. Update and build the Docker image nokorpo/godot-tests. Publish the new version to DockerHub and update `./github/workflows/tests.yaml` to use it.
4. Run everything and check that it works.

## Licensing and legal

This project has 3 parts, each with its own legal terms:

* **Source code**: all code located in the `/modules`, `/addons/gato_screen_filters` and `/addons/input_remapper` os licensed under the [MPL 2.0 license](./LICENSE.md).
* **Graphic assets**: all logos, icons, 3D models and other graphic assets located under `/modules`, `/addons/gato_screen_filters` and `/addons/input_remapper` are licensed under the [Creative Commons Attribution-ShareAlike 4.0 International License (CC BY-SA 4.0)](https://creativecommons.org/licenses/by-sa/4.0/).
* **Trademarks**: the project name "GATO (Godot Accessibility Toolkit)" and the project logo are trademarks of Iseltec S.L. This copyright license does not grant you any right to use these trademarks. As a general rule, you may use the name to refer to the project (e.g., "this game uses the plugin 'GATO: Input Remapper'") but you may not use the logo or imply endorsement. For any doubt, contact info@iseltec.com.

