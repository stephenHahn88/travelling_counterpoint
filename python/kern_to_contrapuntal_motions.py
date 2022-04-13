from typing import List
import re
from collections import defaultdict
from pprint import pprint
from fractions import Fraction
from music21.note import Note as N

def kern_to_midi_num(filepath: str):
    expression = r"(?!=)\d+\.*[a-zA-Z]+[#\-n]*"
    matches = defaultdict(list)
    with open(filepath, "r") as f:
        lines = f.readlines()
    for line in lines:
        if line[0] in ["!", "*"]:
            continue
        for i, voice in enumerate(line.split("\t")):
            search_result = re.search(expression, voice)
            matches[i].append(search_result.group()) if search_result else matches[i].append(".")

    for k in matches.keys():
        matches[k] = [kern_note_to_midi_num(kn) for kn in matches[k]]

    return matches

def rhythm_to_fraction(rhythm: str):
    if rhythm[-1] == ".":
        r = rhythm[:-1]
        f = Fraction(1, int(r))
        return (f + f/2) * 4
    else:
        return Fraction(1, int(rhythm)) * 4

def kern_note_to_midi_num(kern_note: str):
    if kern_note == ".":
        return 0, 99
    expression = r"(\d+\.*)([a-hA-Hr]+)([#\-n]*)"
    search_result = re.search(expression, kern_note)
    rhythm = search_result.group(1)
    note = search_result.group(2)
    accidental = search_result.group(3)

    quarter_length = rhythm_to_fraction(rhythm)

    if note[0] == "r":
        return 0, float(quarter_length)

    if note[0].islower():
        octave = 4 + len(note) - 1
    else:
        octave = 4 - len(note)

    return N(f"{note[0].upper()}{accidental}{octave}").pitch.midi, float(quarter_length)

def midi_num_to_events(midi_nums):
    len1 = len(list(midi_nums.values())[0])
    for v in midi_nums.values():
        if len(v) != len1:
            raise ValueError(f"All values of midi_nums should have same length. Got {len(v)} for one and {len1} for another.")
    events = []
    prev_b, prev_a, prev_s = 60, 60, 60
    voices = [v for v in midi_nums.values()]
    for b, a, s in zip(voices[0], voices[1], voices[2]):
        if a[1] == 99 and b[1] == 99 and s[1] == 99:
            continue
        shortestDuration = min(b[1], a[1], s[1])
        notes, b, prev_b = append_voice([], b[0], prev_b)
        notes, a, prev_a = append_voice(notes, a[0], prev_a)
        notes, s, prev_s = append_voice(notes, s[0], prev_s)
        events.append((shortestDuration, tuple(notes)))
    pprint(events)
    return events

def write_events(filepath: str, events: List):
    with open(filepath, "w") as f:
        for event in events:
            b, a, s = event[1]
            f.write(f"{b}\t{a}\t{s}\t{event[0]}\n")


def append_voice(notes, n, prev_n):
    if n != 0:
        notes.append(n)
        prev_n = n
    else:
        notes.append(prev_n)
    return notes, n, prev_n

if __name__ == "__main__":
    midi_nums = kern_to_midi_num("C:\\Users\\sh597\\Desktop\\travelling_counterpoint\\python\\bach_dsharpm_excerpt.txt")
    events = midi_num_to_events(midi_nums)

    write_events("C:\\Users\\sh597\\Desktop\\travelling_counterpoint\\data\\bach_dsharpm_excerpt.txt", events)





