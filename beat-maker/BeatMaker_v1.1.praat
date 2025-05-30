## BeatMaker.praat 
## (C) Leonidas SILVA JR. (State University of Paraíba, Brazil)
## Script for prosodic information extraction of timing and intonation for voice comparison purposes. 
## This script can be used for voice comparison in:
## i) Pronunciation teaching (native vs. foreign speech ad/or different proficiency levels of foreign accent; 
## ii) Forensic purposes (questioned vs. target voice in a speaker identification scenario, and
## iii) CLinical purposes (regular voice vs. voice with some pathology).
## For the sake of a finer comparison between vices, WE STRONGLY RECOMMEND USING TWO AUDIO FILES PER FOLDER

##------##------##------ HOW TO CITE THIS SCRIPT ------##------##------##
## SILVA JR., Leonidas. (2023-2025) BeatMaker (version 1.1). [Computer program for Praat].
## Available in: <https://github.com/leonidasjr/VowelCode>.
 
form Set the input parameters
	comment 1. *Set intensity threshold for automatic alignment of sound and linguistic information
	real Intensity_threshold_(dB) 45.0
	comment 2. The text file must have the same name of the reference sound
	word Reference_sound L1_speech
	comment 3. Select the primary language spoken in the recording.  
	optionmenu Language 1
		option English (America)
		option English (Great Britain)
		option French (France)
		option German
		option Portuguese (Brazil)
		option Portuguese (Portugal)
		option Spanish (Spain)
		option Spanish (Latin America)
		option Interlingua
	comment 4. Specify the speaker's sex. '*Customize*' lets you manually set pitch thresholds. 
	choice Speaker_sex 2
		button Female
		button Male
		button Customize
	comment 4.1. If 'Speaker sex' is '*Customize*', define the lower and upper F0 (pitch) limits.
	integer left_F0_threshold_(Hz) 0.0
	integer right_F0_threshold_(Hz) 0.0
	comment 5. Pitch contour colors
	optionmenu L1_speech 2
		option Black
		option Red
		option Blue
		option Green
	optionmenu L2_speech 3
		option Black
		option Red
		option Blue
		option Green
endform

## cleaning up plot area
Erase all

## cleaning up Praat's objects window and appended information before workflow
numberOfSelectedObjects = numberOfSelected()
if numberOfSelectedObjects > 0
	select all
	Remove
endif

## Creating TextGrid for the utterance containing automatic start and end boundaries
ref_sound$ = reference_sound$ + ".wav"
Read from file... 'ref_sound$'
sound_file$ = selected$("Sound")
text$ = sound_file$ + ".txt"
text$ = readFile$(text$)

select Sound 'sound_file$'
	Edit
	editor Sound 'sound_file$'
		Intensity settings... 40 100 "mean energy" yes
		Close
	endeditor
select Sound 'sound_file$'
	To TextGrid: "sentence", ""
select Sound 'sound_file$'
	To Intensity... 100 0 0 yes 
	nframes = Get number of frames

## forced alignment of the sentence
for k from 1 to nframes
	int = Get value in frame: k
	if int > 'intensity_threshold'
		time = Get time from frame: k
		select TextGrid 'sound_file$'
		Insert boundary: 1, time
	endif
		select Intensity 'sound_file$'
endfor

select TextGrid 'sound_file$'
	b = 3
	repeat
		intervals = Get number of intervals: 1
		Remove left boundary: 1, b
		intervals = Get number of intervals: 1
	until b = intervals
Set interval text: 1, 2, text$

## forced alignment of words
if language == 1 or language == 2 or language == 3
... or language == 4 or language == 5 or language == 6
... or language == 7 or language == 8 or language == 9
	select Sound 'sound_file$'
		plus TextGrid 'sound_file$'
	View & Edit
	editor TextGrid 'sound_file$'
		Alignment settings: language$, "yes", "no", "yes"
		Align interval
		Close
	endeditor
endif
select TextGrid 'sound_file$'
	Set tier name: 1, "Text"
	Set tier name: 2, "Words"
select all
	minus TextGrid 'sound_file$'
Remove

select TextGrid 'sound_file$'
	Duplicate tier: 2, 1, "Words"
	Remove tier: 3

## Creating a list of sound files with tempo (beat), and TONE (pitch)
Create Strings as file list... audioDataList *.wav
numberOfFiles = Get number of strings

for y from 1 to numberOfFiles
    select Strings audioDataList
    filename$ = Get string... y
    Read from file... 'filename$'
	soundFile$ = selected$ ("Sound")
    language_chr$ = mid$(soundFile$, 1, 2)

	if speaker_sex == 1
    	select Sound 'soundFile$'
			To Pitch... 0.0 90 350
			To Sound (pulses)
			Rename... 'language_chr$'_pulses_temp
		select Pitch 'soundFile$'
			To Sound (sine): 44100, "at nearest zero crossings"
		Multiply: 4
		Rename... 'language_chr$'_sine_temp
	elsif speaker_sex == 2
		select Sound 'soundFile$'
			To Pitch... 0.0 75 200
			To Sound (pulses)
			Rename... 'language_chr$'_pulses_temp
		select Pitch 'soundFile$'
			To Sound (sine): 44100, "at nearest zero crossings"
		Multiply: 4
		Rename... 'language_chr$'_sine_temp
	elsif speaker_sex == 3
		select Sound 'soundFile$'
			To Pitch... 0.0 'left_F0_threshold' 'right_F0_threshold'
			To Sound (pulses)
			Rename... 'language_chr$'_pulses_temp
		select Pitch 'soundFile$'
			To Sound (sine): 44100, "at nearest zero crossings"
		Multiply: 4
		Rename... 'language_chr$'_sine_temp
	endif

	select Sound 'language_chr$'_sine_temp
		plus Sound 'language_chr$'_pulses_temp
	Combine to stereo
	Rename... 'language_chr$'_Beat
	Convert to mono
		plus Sound 'soundFile$'
	Combine to stereo
	Rename... 'language_chr$'_Beat_and_Voice
	select Sound 'language_chr$'_sine_temp
		plus Sound 'language_chr$'_pulses_temp
	Remove
	select Pitch 'soundFile$'
	To Sound (hum)
	Rename... 'language_chr$'_Pitch

	## Plot procedures
	Font size: 14
	Times

	## Pitch contour plot
	if language_chr$ == "L1" or language_chr$ == "NS" or language_chr$ == "RV" or language_chr$ == "V1"
		select Pitch 'soundFile$'
		Smooth: 2
		'l1_speech$'
		Select outer viewport: 0, 10, 0, 4.5
		Draw inner box
		
		if speaker_sex == 1
			Draw: 0, 0, 90, 350, "no"
			Line width: 2
			Draw: 0, 0, 90, 350, "no"
			
			## Procedure: plot Y-axis and X-axis labels for the pitch contours
			call plot_f0_YX_axes
			            
			## Procedure: Plot Voice and Beat signals for the reference voice
			call plot_voice_and_beat_L1

		elsif speaker_sex == 2
			Draw: 0, 0, 75, 200, "no"
			Line width: 2
			Draw: 0, 0, 75, 200, "no"
			
			## Procedure: Plot Y-axis and X-axis labels for the pitch contours
			call plot_f0_YX_axes
			            
			## Procedure: Plot Voice and Beat signals for the reference voice
			call plot_voice_and_beat_L1
		
		elsif speaker_sex == 3
			Draw: 0, 0, 'left_F0_threshold', 'right_F0_threshold', "no"
			Line width: 2
			Draw: 0, 0, 'left_F0_threshold', 'right_F0_threshold', "no"
			## Procedure: plot Y-axis and X-axis labels for the pitch contours 
			call plot_f0_YX_axes
			## Procedure: Plot Voice and Beat signals for the reference voice
			call plot_voice_and_beat_L1
		endif

		## Plot Y-axis and X-axis labels for the pitch contours (*only* for the reference voice)
		procedure plot_f0_YX_axes
			Select outer viewport: 0, 10, 0, 4.5
			Line width: 1
			Marks left: 6, "yes", "yes", "yes"
			Marks bottom: 6, "yes", "yes", "yes"
			Text left: "yes", "Pitch (fundamental frquency in Hz)"
			Text bottom: "yes", "Time (duration in seconds)"
			Line width: 1
		endproc

		## Plot procedure for "Voice & Beat" signals for the reference voice
		procedure plot_voice_and_beat_L1
			Line width: 1
			select Sound 'language_chr$'_Beat_and_Voice
			Select outer viewport: 0, 5, 4.5, 7.5
			Draw: 0, 0, 0, 0, "yes", "curve"
			Text top: "no", "'language_chr$' Voice (%u%p) & Beat (%d%o%w%n)"
			Select outer viewport: 0, 10, 0, 4.5
		endproc

		
        ## Plot TextGrid to match the pitch contours
        select TextGrid 'soundFile$'
		Black
		Select outer viewport: 0, 10, 1.5, 4.5
		Draw: 0, 0, "yes", "yes", "no"

        ## Plot legends for the reference speech
		Font size: 14
		Line width: 1
		Select outer viewport: 7.5, 10, 0, 1.77
		Draw inner box
		'l1_speech$'
		Text special: 1, "left", 0, "half", "Helvetica", 15, "0", language_chr$

		select Pitch 'soundFile$'
		Remove
		select Pitch 'soundFile$'
			plus Sound 'language_chr$'_Beat_mono
		Remove
	
	elsif language_chr$ == "L2" or language_chr$ == "FS" or language_chr$ == "CV" or language_chr$ == "V2"
		
	## Plot legends for the comparison speech
        'l2_speech$'
        Select outer viewport: 7.5, 10, 0, 1.77
		Text special: 1, "left", -1, "half", "Helvetica", 15, "0", language_chr$
		select Pitch 'soundFile$'
		Smooth: 2
		'l2_speech$'
		Select outer viewport: 0, 10, 0, 4.5
		Draw inner box
		Line width: 2
		Line width: 1
		Select outer viewport: 0, 10, 0, 4.5
		Draw inner box
		
		if speaker_sex == 1
			Draw: 0, 0, 90, 350, "no"
			Line width: 2
			Draw: 0, 0, 90, 350, "no"
			## Procedure: Plot Voice and Beat signals for the comparison voice
			call plot_voice_and_beat_L2
		
		elsif speaker_sex == 2
			Draw: 0, 0, 75, 200, "no"
			Line width: 2
			Draw: 0, 0, 75, 200, "no"
            		## Procedure:  Plot Voice and Beat signals for the comparison voice
			call plot_voice_and_beat_L2
		
		elsif speaker_sex == 3
			Draw: 0, 0, 'left_F0_threshold', 'right_F0_threshold', "no"
			Line width: 2
			Draw: 0, 0, 'left_F0_threshold', 'right_F0_threshold', "no"
			## Procedure: Plot Voice and Beat signals for the comparison voice
			call plot_voice_and_beat_L2
        	endif

		## Plot procedure for "Voice & Beat" signals for the comparison voice
		procedure plot_voice_and_beat_L2
			Line width: 1
			select Sound 'language_chr$'_Beat_and_Voice
			Select outer viewport: 4.5, 9.5, 4.5, 7.5
			Draw: 0, 0, 0, 0, "yes", "curve"
			Text top: "no", "'language_chr$' Voice (%u%p) & Beat (%d%o%w%n)"
			Select outer viewport: 0, 10, 0, 7.5
		endproc
		
		select Pitch 'soundFile$'
		Remove
		select Pitch 'soundFile$'
			plus Sound 'language_chr$'_Beat_mono
		Remove
	else
		exitScript "WARNING! Your files must be tagged with at least the characters: 
		... L1 or NS or V1 or RV (Reference voice) 
		... and L2 or FS or V2 or CV (Comparison voice)"
		Remove
		select Pitch 'soundFile$'
			plus Sound 'language_chr$'_Beat_mono
		Remove
	endif
endfor

pauseScript: "Save plots?"
	plot_name$ = "BeatMaker_Plots"
	Save as 600-dpi PNG file: plot_name$ + ".jpg"
	writeInfoLine: plot_name$ + ".jpg" + " saved"

select Strings audioDataList
Remove