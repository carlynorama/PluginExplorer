# Plugin Explorer


See also https://www.whynotestflight.com/excuses/what-if-instead-of-a-cli-plugins-part-1-command-plugins/ 

[BPE]: https://github.com/carlynorama/BuildPluginExample/ "repo for the plugin"
[BPET]: https://github.com/carlynorama/BuildPluginExampleTarget/ "repo for the cli that imports the plugin"

[PT1]: https://www.whynotestflight.com/excuses/what-if-instead-of-a-cli-plugins-part-1-command-plugins/ 
[PT2]: https://www.whynotestflight.com/excuses/what-if-instead-of-a-cli-plugins-part-2-start-a-build-plugin/
[PT3]: https://www.whynotestflight.com/excuses/what-if-instead-of-a-cli-plugins-part-3-the-actual-code-gen/
[PT4]: https://www.whynotestflight.com/excuses/what-if-instead-of-a-cli-plugins-part-4-prebuild-plugins-misc/

Repo for exploring how to make Package Plugins.

## Plugins

- **TellMeAboutYourself**: Command Plugin. Write a report about the target to a file at the top level of the target. Discussed in WhyNoTestFlight plugin series [part 1][PT1]
- **MyInBuildPlugin**: Makes code based on text files. See also [BuildPluginExample][BPE] and [BuildPluginExample][BPET], Discussed on WhyNotTestFlight [Start Up][PT2], [Code Gen][PT3]
- **MyPreBuildPlugin**: Experiments in making zip files and where they can be put. Discussed on plugin series [part 4][PT4]
- **ScreamIntoTheVoid**: Trying to figure out where all the pipes are (STOUT, STDERR for plugin, for tool, etc.). WIP. 
- **BuildNRun**: Also [part 4][PT4]. A command plugin that manages a build via the packageManager proxy. 

            
## Handy Commands For Running Command Plugins 

```bash
swift package plugin --list
swift package $PLUGIN_VERB
swift package --allow-writing-to-package-directory $PLUGIN_VERB
swift package --disable-sandbox $PLUGIN_VERB
```

# Handy Commands for Generating Projects

```bash
swift package init --type tool #Comes with argument parser
swift package init --type build-tool-plugin
swift package init --type command-plugin
```

## Handy Rules of Thumb

- run on demand, makes edits to source/package folder: command plugin
- run only if resources are missing or stale: build plugin
- run every build, before the build: pre-build plugin


## Gotchas

- Code generated by build plugins is generally detectable by IDE's, but the build tool has to have been run at least once before you can use it.
- Code only associated with a `.plugin` target doesn't get swept up in targets, and build problems can only be found in the build logs. Code also in its own stand alone tool does get more regular treatment. Prioritize putting as much as possible into a tool and as little a possible only in a plugin. 
- Write the tool and get it completely working, then write the plugin.
- stdout for a tool does not always work as expected. 
- For two plugins to share code they need to both depend on the same executable or a binary, not a non-productized library target. [See discussion](https://forums.swift.org/t/difficulty-sharing-code-between-swift-package-manager-plugins/61690/3)
- Adding new files to the source directory is expensive to build plugins. It will rerun not just the plugin, but regenerate every command and run the tool(s). 

            
## References

### Official
- WWDC 2022 [Meet Swift Package plugins](https://developer.apple.com/videos/play/wwdc2022/110359)
- WWDC 2022 [Create Swift Package plugins](https://developer.apple.com/videos/play/wwdc2022/110401/)
- https://github.com/apple/swift-package-manager/
- https://forums.swift.org/t/pitch-package-manager-command-plugins/53172
- https://github.com/apple/swift-evolution/blob/main/proposals/0332-swiftpm-command-plugins.md
- https://github.com/apple/swift-package-manager/blob/main/Documentation/Plugins.md


### Misc Interesting Repos
- Example bringing in linting from `MessageKit` https://github.com/MessageKit/MessageKit/tree/3fab2f2d7f04b0f7ec19e2bfab0f614fef884ff8/Plugins
- https://github.com/SwiftGen/SwiftGenPlugin
- https://github.com/realm/SwiftLint/tree/main/Plugins/SwiftLintPlugin
- https://github.com/apple/swift-docc-plugin
- https://github.com/apple/swift-openapi-generator/tree/main/Plugins
- https://github.com/lighter-swift


