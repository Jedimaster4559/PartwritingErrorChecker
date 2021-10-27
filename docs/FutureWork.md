# Future Work
There are a number of pieces of future work that I would like to complete with this software.

## Simplifying the Installation Process
While the current installation process isn't very complex, it isn't extremely simple either. Ideally, someone with extremely minimal technical knowledge should be able to install this plugin. This would be particularly helpful as musicians are not always the most technically adept people.

One thing that could be done to simplify the installation process would be to to write some basic installation scripts. This would be particularly helpful if eventually the code-base for the plugin expands to be more than one file. This update could be as simple as adding `.sh` or `.bat` scripts that find the Musescore installation and move all the appropriate files to the correct location. It may be possible to even have the script be the only file the user needs to download through use of the "wget" or "curl" commands (although this may be viewed as insecure).

It also might be beneficial to provide the plugin as an `.exe` or as an OSX application, perhaps even packaging the plugin with musescore itself. This would have the advantage that this software would have a very similar installation process to any other legitimate piece of software. The one downfall of this could be that anyone on a managed system may have difficult getting permissions to install the plugin on their system. If this option was pursued, there would need to be documentation on "installing the plugin from source" such that users with restrictive system administrators can still use the plugin.

## Improving Availability
While the software is open source and available for anyone to use, it is not very well known or easy to find. Some additional work may need to be performed to raise awareness of this tool's existance.

Musescore maintains a list of plugins that the community has built. Adding this software to that list will make it more visible to the community that already uses Musescore

Adding search engine optimization (SEO) to the plugin's documentation site could help users searching Google for this tool find it more quickly.

Additionally, reaching out to music theory instructors may prove to be the most effective method of promoting this plugin. These instructors have access to a large number of students and are in a strong position to encourage use of this tool.
- TODO: Add link to plugin list

## Impoving Configuration Options
Right now, the software has minimal configuration options. The options that do exist require the user to edit the source code of the plugin, which is less than ideal. Implementing a system to allow the users to configure these options from within the plugin may greatly improve the user experience. Additionally, adding persistance through some type of coniguration file would prevent the user from having to constantly update their preferences any time they open the plugin.

Many pieces of the software have certain ranges or spacings that are allowed. Several of these (such as standard ranges for a given part) are somewhat debated. Allowing configuration from within the plugin (or on a sub-menu of the plugin) would make updating these values much simpler.

The current options for colors in the application are not yet optimal. Several of the colors are very similar and can be tough to differential. Additionally, no colorblind considerations have been made. It would be very helpful to the accessibility of the software to either optimze the color selections or to find another alternative, such as changing the shape of the note heads.

## Additional Features
There are a number of additional features that I would like to add to this software at some point in the future.

### Integration with other plugins
There are several other plugins that provide additional capabilities that students may beneficial to their learning experience.

#### Chord Identifier Plugin
The [Chord Identifier Plugin](https://github.com/animikatamon/MuseScorePlugins) by @animikatamon is a tool that can provide a basic roman numeral analysis of a piece of music. While there is no way to provide verification that these symbols were the ones that the student expected, they could perform a manual comparison with this tool to ensure the accuracy of their work.

#### TODO: Identify other similar Plugins
Find other plugins. 

### Adding Musescore Shapes
Musescore has a feature where you can add shapes or symbols to a score. Many of these are legitmate notational symbols but some of them can be used to great success when attempting to accurately mark errors in partwriting. For example, it is very common to use a set of parallel lines between notes to indicate parallel fifths or octaves. It may also make sense to use a set of brackets to indicate range or spacing errors.

Initially, it was my goal to add this feature to the software however I found that the current API for Musescore has no support for adding these symbols. It may not be possible at this point in time however Musescore is an open-source piece of software. If this feature was needed or desired, it may be possible to create an update to the Musescore API to allow for this feature to be implemented in the plugin.

### Advanced Partwriting Techniques
There are several partwriting techniques that were left unsupported or untested due to complexity and/or time constraints.

The software does not support concepts such as key changes, borrowed chords (TODO: verify this is what this is actually called)

### Musicality
As mentioned in the "Effective Use" section of this site, this tool does not provide feedback on musicality. There are several approaches that might be taken to resolve this issue, but perhaps the most interesting of these would be to implement a machine learning algorithm that can differentiate between different valid solutions. 

There have been a number of similar attempts to implement software such as this, however they all tend to suffer from similar problems. These typically fall somewhere in the area of needing too much data to properly train the data model. Additionally, the lines between good and bad are much more blurred than traditional uses of machine learning, making this even more challenging to implement.

TODO: Identify Similar Examples
TODO: Make Comparison to training images of dogs
- How many images of dogs are required.
- How long does it take to take a picture of a dog
- Physical size of the data.

## Improving Reliability
Testing is an important part of the design process. While this software has been tested by both its developer and a number of independent parties (See "Testing" section of this site), there are much more extensive options for effectively testing this plugin.

One option would be to investigate the set of testing options implemented in Musescore itself. They have their own test suite that may be adapted to better fit automated testing needs of this plugin. Even if this proves to not be an option, it may be possible to attach a generic QML unit testing library to this project and get a high degree of coverage through mocking Musescore resources.

Finally, as the software is used by more people, more edge cases will be reached and more feedback will be collected.
