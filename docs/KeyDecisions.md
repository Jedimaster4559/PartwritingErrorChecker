# Key Decisions
While working on this project, there were several important key decisions that were made.

## Audience
The target audience for this tool was the first decision made. The audience was the first thing considered when making any other important decisions for the project.

This software is entirely targerted towards students. The ultimate goal is to help facilitate student learning and provide a key resource to help their success.

## Musescore
There were several alternatives to using Musescore for the implementation of this tool however in the end it made more sense than the alternatives.

### Why not Finale or Sibaleus
Finale and Sibaleus are alternative notation softwares that are popular in industry. Unfortunately, these tools are very expensive, and thus most students don't use  them. Some universities provide these to students, however in the interest of allowing access to the most students possible, a free alternative (musescore) was chosen.

While the final decision was to use musescore, it is not impossible for Finale and Sibaleus users to use this tool. Students can export their work in alternative softwares to MusicXML (TODO: insert links/documentation) to move their music from one notation software to another. While the students will still need to download and use musescore for the actual error checking, they can write their music in their tool of choice.

### Why not a custom tool built from scratch
Building a tool from scratch would have taken too much time. Tools such as musescore have a large number of features that have already had extensive thought and time put into them. It just didn't make sense to invest time into re-implementing the features in my own piece of software when I could just use what already existed in musescore. 

For example:<br>
- Notation: At a minimum, some kind of notation would be needed to give a good visual representation of the errors. This challenge by itself would have probably taken longer to implement than the rest of the project and still would not have been able to match the quality of many of the mainstream notation softwares. Musescore themselves recently recently rebuilt their notation system and created an excellent video illustrating the difficulty of this processes. (TODO: Add link to Youtube Video).<br>
- Audio Playback: While not essential to the project, audio playback is a very helpful feature to have as it allows students to connect both valid and invalid partwriting with how it sounds. A custom implemtation of this would have likely taken some complicated work involving midi, and other audio playback. This is another feature that probably would have taken nearly as long as the core project.<br>
- XML Parsing: While this feature wouldn't have been as difficult to handle since MusicXML has a public schema (TODO: Insert link), it was another option that just didn't make a lot of sense. Musescore already had this feature implemented.

### Musescore
Musescore is already a very powerful notation software and is free to use. It is already used by a large number of students, so the barrier to entry to use this error identifier would be low.

Additionally, musescore has a plugins feature allowing custom tools built using QML to be run.