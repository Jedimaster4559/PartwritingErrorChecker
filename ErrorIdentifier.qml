//=============================================================================
//
//=============================================================================

import MuseScore 3.0
import QtQuick 2.0

import QtQuick.Layouts 1.0
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import Qt.labs.settings 1.0

MuseScore {
    menuPath: "Plugins.Analysis.Partwriting Error Identifier"
    description: 'Automatically Identify Errors in Partwriting'
    version: "0.0.1"
    pluginType: "dialog"

    // Allowed Part Range Configurations
    property int sopranoHighestNote  :   79      // G5
    property int sopranoLowestNote   :   60      // C4
    property int altoHighestNote     :   72      // C5
    property int altoLowestNote      :   55      // G3
    property int tenorHighestNote    :   67      // G4
    property int tenorLowestNote     :   48      // C3
    property int bassHighestNote     :   60      // C4
    property int bassLowestNote      :   40      // E2

    // Maximum Spacing Configuration
    property int sopranoAltoMaxDistance     :   12  // P8
    property int altoTenorMaxDistance       :   12  // P8
    property int tenorBassMaxDistance       :   24  // P15

    // Error Counters
    property int totalErrorCount            :   0
    property int rangeErrorCount            :   0
    property int melodicDissonanceCount     :   0
    property int spacingErrorCount          :   0
    property int crossedVoicesErrorCount    :   0
    property int parallelErrorCount         :   0
    property int hiddenFifthErrorCount      :   0
    property int diminishedFifthErrorCount  :   0

    // Error Colors
    property variant noErrors                   : "#000000"   // Black
    property variant rangeErrorColor            : "#CCCC00"   // Dark Yellow
    property variant melodicDissonanceColor     : "#0000FF"   // Blue
    property variant spacingErrorColor          : "#008000"   // Green
    property variant crossedVoicesColor         : "#008080"   // Teal
    property variant parallelErrorColor         : "#ff0000"   // Red
    property variant hiddenFifthsColor          : "#4040ff"   // Not Sure what color this is
    property variant diminishedFifthColor       : "#800080"   // Purple

    // Sorts an array of notes so that the lowest note is at the start of the
    // array and the highest note is at the end. This makes some assumptions
    // but could prove useful in some cases
    function sortNoteArray(notes) {
        if(notes.length == 0) {
            return notes;
        }
        var sorted = false;
        var index = 0;
        while(!sorted) {
            if(index + 1 < notes.length) {
                if(notes[index+1].pitch < notes[index]) {
                    var temp = notes[index];
                    notes[index] = notes[index + 1]
                    notes[index+1] = temp;
                    index = 0
                }
            } else {
                sorted =  true;
            }
        }
    }

    // A basic absolute value function
    function abs(value) {
        if (value < 0) {
            return value * -1;
        } else {
            return value;
        }
    }

    // Labels any Range errors.
    function labelRangeErrors(chord) {
        if(chord.length != 4) {
            // TODO: Decide what to do in these kind of situations
            console.log('I saw too many notes here!')
        }

        // Check Bass
        if(chord[0].pitch < bassLowestNote) {
            console.log('Range Error Found!');
            chord[0].color = rangeErrorColor;
            totalErrorCount++;
            rangeErrorCount++;
        }
        if(chord[0].pitch > bassHighestNote) {
            console.log('Range Error Found!');
            chord[0].color = rangeErrorColor;
            totalErrorCount++;
            rangeErrorCount++;
        }

        // Check Tenor
        if(chord[1].pitch < tenorLowestNote) {
            console.log('Range Error Found!');
            chord[1].color = rangeErrorColor;
            totalErrorCount++;
            rangeErrorCount++;
        }
        if(chord[1].pitch > tenorHighestNote) {
            console.log('Range Error Found!');
            chord[1].color = rangeErrorColor;
            totalErrorCount++;
            rangeErrorCount++;
        }

        // Check Alto
        if(chord[2].pitch < altoLowestNote) {
            console.log('Range Error Found!');
            chord[2].color = rangeErrorColor;
            totalErrorCount++;
            rangeErrorCount++;
        }
        if(chord[2].pitch > altoHighestNote) {
            console.log('Range Error Found!');
            chord[2].color = rangeErrorColor;
            totalErrorCount++;
            rangeErrorCount++;
        }

        // Check Soprano
        if(chord[3].pitch < sopranoLowestNote) {
            console.log('Range Error Found!');
            chord[3].color = rangeErrorColor;
            totalErrorCount++;
            rangeErrorCount++;
        }
        if(chord[3].pitch > sopranoHighestNote) {
            console.log('Range Error Found!');
            chord[3].color = rangeErrorColor;
            totalErrorCount++;
            rangeErrorCount++;
        }
        
    }

    function findRangeErrors(all_chords) {
        for (var i = 0; i < all_chords.length; i++) {
            labelRangeErrors(all_chords[i]);
        }
    }

    function labelMelodicDissonanceErrors(note1, note2) {
        var dist = note1.tpc1 - note2.tpc1;
        if(dist < 0) {
            dist = dist * -1;
        }

        if(dist >= 6) {
            // Indicates a Melodic Dissonance Error
            console.log("Melodic Dissonance Error Found. Dist: " + dist);
            note1.color = melodicDissonanceColor;
            note2.color = melodicDissonanceColor;
            totalErrorCount++;
            melodicDissonanceCount++;
        }
    }
    
    function findMelodicDissonanceErrors(all_chords) {
        for(var i = 0; i < 4; i++) {
            for(var j = 0; j < all_chords.length - 1; j++){
                labelMelodicDissonanceErrors(all_chords[j][i], all_chords[j+1][i]);
            }
        }
    }

    function labelSpacingErrors(chord) {
        // Calculate Spacings
        var tenorBassSpacing = chord[1].pitch - chord[0].pitch;
        var altoTenorSpacing = chord[2].pitch - chord[1].pitch;
        var sopranoAltoSpacing = chord[3].pitch - chord[2].pitch;

        if(tenorBassSpacing > tenorBassMaxDistance) {
            console.log("Spacing Error Found!");
            chord[0].color = spacingErrorColor;
            chord[1].color = spacingErrorColor;
            totalErrorCount++;
            spacingErrorCount++;
        }

        if(altoTenorSpacing > altoTenorMaxDistance) {
            console.log("Spacing Error Found!");
            chord[1].color = spacingErrorColor;
            chord[2].color = spacingErrorColor;
            totalErrorCount++;
            spacingErrorCount++;
        }

        if(sopranoAltoSpacing > sopranoAltoMaxDistance) {
            console.log("Spacing Error Found!");
            chord[2].color = spacingErrorColor;
            chord[3].color = spacingErrorColor;
            totalErrorCount++;
            spacingErrorCount++;
        }
    }

    function findSpacingErrors(all_chords) {
        for(var i = 0; i < all_chords.length; i++) {
            labelSpacingErrors(all_chords[i]);
        }
    }

    function labelCrossedVoices(chord) {
        if(chord[0].pitch > chord[1].pitch) {
            console.log("Crossed Voices Found!");
            chord[0].color = crossedVoicesColor;
            chord[1].color = crossedVoicesColor;
            totalErrorCount++;
            crossedVoicesErrorCount++;
        }

        if(chord[1].pitch > chord[2].pitch) {
            console.log("Crossed Voices Found!");
            chord[1].color = crossedVoicesColor;
            chord[2].color = crossedVoicesColor;
            totalErrorCount++;
            crossedVoicesErrorCount++;
        }

        if(chord[2].pitch > chord[3].pitch) {
            console.log("Crossed Voices Found!");
            chord[2].color = crossedVoicesColor;
            chord[3].color = crossedVoicesColor;
            totalErrorCount++;
            crossedVoicesErrorCount++;
        }
    }

    function findCrossedVoices(all_chords) {
        for(var i = 0; i < all_chords.length; i++) {
            labelCrossedVoices(all_chords[i]);
        }
    }

    function labelParallels(chord1, chord2) {
        for(var i = 0; i < chord1.length - 1; i++) {
            for(var j = i + 1; j < chord1.length; j++) {
                // Calculate intervals between pitches
                var chord1Diff = chord1[j].pitch - chord1[i].pitch;
                var chord2Diff = chord2[j].pitch - chord2[i].pitch;

                // Determine Parallel
                var isParallel = chord1Diff == chord2Diff;

                // Correct for wider ranges
                chord1Diff = chord1Diff % 12;
                chord2Diff = chord2Diff % 12;

                // Check Octaves
                if(isParallel && chord1Diff == 0) {
                    console.log("Parallel Octaves Found");
                    chord1[i].color = parallelErrorColor;
                    chord1[j].color = parallelErrorColor;
                    chord2[i].color = parallelErrorColor;
                    chord2[j].color = parallelErrorColor;
                    totalErrorCount++;
                    parallelErrorCount++;
                }

                // Check Fifths
                if(isParallel && chord1Diff == 7) {
                    console.log("Parallel Fifths Found");
                    chord1[i].color = parallelErrorColor;
                    chord1[j].color = parallelErrorColor;
                    chord2[i].color = parallelErrorColor;
                    chord2[j].color = parallelErrorColor;
                    totalErrorCount++;
                    parallelErrorCount++;
                }
            }
        }
    }

    function findParallels(all_chords) {
        for(var i = 0; i < all_chords.length - 1; i++) {
            labelParallels(all_chords[i], all_chords[i+1]);
        }
    }

    function labelHiddenFifthsAndOctaves(chord1, chord2) {
        var sopPitchDifference = chord2[3].pitch - chord1[3].pitch;
        var bassPitchDifference = chord2[0].pitch - chord1[0].pitch;
        var chord2Interval = (chord2[3].pitch - chord2[0].pitch) % 12;

        var isSopLeap = abs(sopPitchDifference) > 2;
        var isSameDirection = false;
        var isBadInterval = false;

        if(sopPitchDifference > 0 && bassPitchDifference > 0) {
            isSameDirection = true;
        }
        
        if(sopPitchDifference < 0 && bassPitchDifference < 0) {
            isSameDirection = true;
        }

        if(chord2Interval == 0 || chord2Interval == 7) {
            isBadInterval = true;
        }

        if(isSopLeap && isSameDirection && isBadInterval) {
            console.log("A Hidden fifth or octave was found!");
            chord1[0].color = hiddenFifthsColor;
            chord1[3].color = hiddenFifthsColor;
            chord2[0].color = hiddenFifthsColor;
            chord2[3].color = hiddenFifthsColor;
            totalErrorCount++;
            hiddenFifthErrorCount++;
        }

    }

    function findHiddenFifthsAndOctaves(all_chords) {
        for(var i = 0; i < all_chords.length - 1; i++) {
            labelHiddenFifthsAndOctaves(all_chords[i], all_chords[i+1]);
        }
    }

    function labelDiminishedFifthResolutionErrors(chord1, chord2) {
        for(var i = 0; i < chord1.length - 1; i++) {
            for(var j = i + 1; j < chord1.length; j++) {
                // Calculate intervals between pitches
                var chord1Diff = chord1[j].pitch - chord1[i].pitch;
                var chord2Diff = chord2[j].pitch - chord2[i].pitch;

                if(chord1Diff == 6 && chord2Diff == 7) {
                    console.log("Found an improper diminished fifths resolution.");
                    chord1[i].color = diminishedFifthColor;
                    chord1[j].color = diminishedFifthColor;
                    chord2[i].color = diminishedFifthColor;
                    chord2[j].color = diminishedFifthColor;
                    totalErrorCount++;
                    diminishedFifthErrorCount++;
                }
            }
        }
    }

    function findDiminishedFifthResolutionErrors(all_chords) {
        for(var i = 0; i < all_chords.length - 1; i++) {
            labelDiminishedFifthResolutionErrors(all_chords[i], all_chords[i+1]);
        }
    }

    // Borrowed from chord identifier pop jazz.qml
    function chordDuration(chord){
        var duration = chord.globalDuration;    // only from MS 3.5 onwards
        if ( !duration )
            duration = chord.duration;
        return duration.ticks;
    }

    // Borrowed from chord identifier pop jazz.qml
    function getAllCurrentNotes(cursor, startStaff, endStaff, onlySelected, prev_chord){
        var full_chord = [];
        var tickLogged = false;
        for (var staff = endStaff; staff >= startStaff; staff--) {
            for (var voice = 3; voice >=0; voice--) {
                var trackLogged = false;
                cursor.voice = voice;
                cursor.staffIdx = staff;
                if (cursor.element && cursor.element.type == Element.CHORD) {
                    var notes = cursor.element.notes;
                    for (var i = 0; i < notes.length; i++) {
                        if (onlySelected && !notes[i].selected)
                            continue;
                        if ( !tickLogged ) {
                            console.log('>>>>> tick ' + cursor.tick);
                            tickLogged = true;
                        }
                        if ( !trackLogged ) {
                            console.log('     >> s'+staff+' v'+voice+'   duration:'+chordDuration(cursor.element));
                            trackLogged = true;
                        }
                        full_chord.push(notes[i]);
						console.log('       >> pitch:' + notes[i].pitch);
                    }
                }
            }
        }
		if (prev_chord) {
			for (var i = 0; i < prev_chord.length; i++) {
				var note = prev_chord[i];
				var excl = (note.parent.parent.tick + chordDuration(note.parent) > cursor.tick ? "!!!" : "");
				if (excl && settings.entire_note_duration)
					full_chord.push(note);
			}
		}

        if (cursor.element && cursor.element.type != Element.CHORD) {
            console.log('Found Other: ' + cursor.element.type);
        }
		
        return full_chord;
    }

    // Borrowed from chord identifier pop jazz.qml
    function setToClosestNextElement(cursor, elemType) {
        // move cursor to closest next segment with Element elemType, whatever the track
        var seg = cursor.segment;
        if ( !seg )
            return false;
        while(seg = seg.next) {
            // console.log('   next seg: tick='+seg.tick);
            var tr;
            for (tr = 0; tr < curScore.ntracks; tr++) {
                var el = seg.elementAt(tr);
                // if (el) console.log('      track#'+tr+' of type '+el.userName());
                if (el && el.type == elemType)
                    break;
            }
            if (tr < curScore.ntracks) {
                cursor.track = tr;
                while (cursor.tick < seg.tick)
                    cursor.next();
                if (cursor.tick > seg.tick)
                    console.log('BUG!!! cursor('+cursor.tick+') went beyond seg('+seg.tick+') !!');
                return true;
            } else {
                // console.log('      required element not found');
            }
        }
        if ( !seg ) {
            // reached end without finding Element Type
            return false;
        }
    }

    function clearAllColors(cursor, startStaff, endStaff, fullScore) {
        // Iterate over the score to identify errors
        cursor.rewind(Cursor.SCORE_START);  // start from beginning of score
        var segment;
        while (segment=cursor.segment) {
            var full_chord = getAllCurrentNotes(cursor, startStaff, endStaff, !fullScore, full_chord);
            
            for(var i = 0; i < full_chord.length; i++){
                full_chord[i].color = noErrors;
            }
            
            if ( !setToClosestNextElement(cursor, Element.CHORD) )
                break;
        }
    }

    function clearAllColorsQuick() {
        var cursor = curScore.newCursor(),
            startStaff = 0,
            endStaff = curScore.nstaves - 1,
            fullScore = (curScore.selection.elements.length <= 1); // ignore accidental note or element

        clearAllColors(cursor, startStaff, endStaff, fullScore);
    }

    function buildNotesArray(cursor, startStaff, endStaff, fullScore) {
        cursor.rewind(Cursor.SCORE_START)

        // Count number of chords and build array
        var segment;
        var numSegments = 0;
        var all_chords = [];
        while (segment=cursor.segment) {
            var full_chord = getAllCurrentNotes(cursor, startStaff, endStaff, fullScore, full_chord);
            numSegments++;
            all_chords.push(full_chord);

            if (!setToClosestNextElement(cursor, Element.CHORD)) break;
        }
        console.log('Found ' + numSegments + ' Chords');

        return all_chords;
    }

    function startAnalysis() {
        // For now, borrowed from chord identifier plugin

        // Start a new Cursor (used to navigate the score)
        var cursor = curScore.newCursor(),
            startStaff = 0,
            endStaff = curScore.nstaves - 1,
            fullScore = (curScore.selection.elements.length <= 1); // ignore accidental note or element
    
        console.log('startStaff: ' + startStaff);
        console.log('endStaff: ' + endStaff);
        console.log('curScore.nstaves: ' + curScore.nstaves);

        // Reset all coloring in the case that errors have been resolved
        clearAllColors(cursor, startStaff, endStaff, fullScore);

        // Identify both possible key signatures
        cursor.rewind(Cursor.SCORE_START);  // start from beginning of score
        var keySig = cursor.keySignature;
        // var keysig_name_major = getNoteName(keySig+7+7);
        // var keysig_name_minor = getNoteName(keySig+7+10);
        // console.log('559: keysig: ' + keySig + ' -> '+keysig_name_major+' major or '+keysig_name_minor+' minor.');

        var all_chords = buildNotesArray(cursor, startStaff, endStaff, !fullScore);
        findRangeErrors(all_chords);
        findMelodicDissonanceErrors(all_chords);
        findSpacingErrors(all_chords);
        findCrossedVoices(all_chords);
        findParallels(all_chords);
        findHiddenFifthsAndOctaves(all_chords);
        findDiminishedFifthResolutionErrors(all_chords)

        // Iterate over the score to identify errors
        // var segment;
        // while (segment=cursor.segment) {
        //     var full_chord = getAllCurrentNotes(cursor, startStaff, endStaff, !fullScore, full_chord);
        //     // labelRangeErrors(full_chord);
            
        //     if ( !setToClosestNextElement(cursor, Element.CHORD) )
        //         break;
        // }


    }

    onRun: {
        startAnalysis();
        console.log('Total Errors: ' + totalErrorCount);
    }

    id: mainDialog

    width:  500
    height: 400

    ColumnLayout {
        id: errorsFoundDisplay
        anchors.left: Button.right
        
        RowLayout {
            id: intro
            spacing: 20
            Text { text: "  Welcome to the partwriting Error Identifier"; font.bold: true }
        }

        RowLayout {
            id: columnHeaderRow
            spacing: 10
            Text { text: "  Color:"; font.bold: true }
            Text { text: "Error Type:"; font.bold: true }
            Text { text: "Num Errors:"; font.bold: true }
        }

        RowLayout {
            id: rangeErrorRow
            spacing: 10
            Text { text: " [Insert Note]"; color: rangeErrorColor }
            Text { text: "Range Errors" }
            Text { text: rangeErrorCount }
        }

        RowLayout {
            id: melodicDissonanceErrorRow
            spacing: 10
            Text { text: " [Insert Note]"; color: melodicDissonanceColor }
            Text { text: "Melodic Dissonance Errors" }
            Text { text: melodicDissonanceCount }
        }

        RowLayout {
            id: spacingErrorRow
            spacing: 10
            Text { text: " [Insert Note]"; color: spacingErrorColor }
            Text { text: "Spacing Errors" }
            Text { text: spacingErrorCount }
        }

        RowLayout {
            id: crossedErrorRow
            spacing: 10
            Text { text: " [Insert Note]"; color: crossedVoicesColor }
            Text { text: "Crossed Voices Errors" }
            Text { text: crossedVoicesErrorCount }
        }

        RowLayout {
            id: parallelErrorRow
            spacing: 10
            Text { text: " [Insert Note]"; color: parallelErrorColor }
            Text { text: "Parallel 5ths/8va Errors" }
            Text { text: parallelErrorCount }
        }

        RowLayout {
            id: hiddenFifthsErrorRow
            spacing: 10
            Text { text: " [Insert Note]"; color: hiddenFifthsColor }
            Text { text: "Hidden Fifths Errors" }
            Text { text: hiddenFifthErrorCount }
        }

        RowLayout {
            id: diminishedFifthErrorRow
            spacing: 10
            Text { text: " [Insert Note]"; color: diminishedFifthColor }
            Text { text: "Diminished Fifth Resolution Errors" }
            Text { text: diminishedFifthErrorCount }
        }

        RowLayout {
            id: totalErrorsRow
            spacing: 20
            Text { text: "  Total Errors:"; font.bold: true }
            Text { text: totalErrorCount; font.bold: false }
        }
    }

    Button {
        id: buttonOK
        text: qsTr("OK")
        anchors.bottom: mainDialog.bottom
        anchors.right:  mainDialog.right
        anchors.bottomMargin: 10
        anchors.rightMargin: 10
        width: 100
        height: 40
        onClicked: {
            Qt.quit();
        }
    }

    Button {
        id: buttonClearColors
        text: qsTr("Clear Colors")
        anchors.bottom: mainDialog.bottom
        anchors.right:  buttonOK.left
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        width: 100
        height: 40
        onClicked: {
            curScore.startCmd();
            clearAllColorsQuick();
            curScore.endCmd();
        }
    }
}


