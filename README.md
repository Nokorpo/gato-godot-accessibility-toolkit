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

