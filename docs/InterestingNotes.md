# Interesting Notes
Tonal Pitch Class (Maybe not? The thing where augmented vs. diminished are all outside certain bounds).

## Tonal Pitch Class
One of the partwriting mistakes that this software can detect is melodic dissonances. This actually was a very interesting to implement. 

Initially I thought I would have to implement a complex system to determine the qualities of intervals. This likely would have involved some combination of the equivalent MIDI values of the notes and some concept of accidentals. This implementation likely would have been vulnerable to odd edge cases and generall would be inelegant. As a result, I began looking through the Musescore Plugin documentation for a better solution. This is when I found a concept called "Tonal Pitch Class" (TPC).

Tonal Pitch class gives notes a numberic value that is based on its note namme and accidental. It has no concept of octave so and "F#" in any octave will always have the same tonal pitch class value. An outline of the values per note can be seen in the image here:
- TODO: Insert image.

What is interesting about this is that the values change based on the circle of fifths which has a number of unique properties. One of these is that the number of fifths from one not to another can provide insite into the quality of the interval. The Ranges for this work as follows:

Distance between notes (in fifths), Quality
<= -6, ? Interval
-6 < note < -1, All ? Intervals
-1, P4 or P5
0, Unison (P1 or P8)
1, P4 or P5
1 < note < 6, All ? Intervals
>= 6, ? Interval

Since we can use this to determine the quality of the note, we now have an easy check for the quality of a given interval:
```qml
quality=abs(note1.tpc - note2.tpc)
```

This implementation is much more elegant than the original design and also has much fewer edge cases that could potentially lead to bugs. Overall, this was one of my favorite components of this plugin to implement.