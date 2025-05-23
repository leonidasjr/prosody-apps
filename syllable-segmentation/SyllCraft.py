import eng_to_ipa as ipa
from tabulate import tabulate
import tkinter as tk
from tkinter import simpledialog
import tkinter.font as tkFont
import pyphen

# List of IPA vowel symbols
ipa_vowels = ['i', 'ɪ', 'e', 'ɛ', 'æ',
              'ə', 'ʌ', 'ɜ', 'ɑ', 'ɒ', 
              'ɔ', 'o', 'ʊ', 'u',
              # syllabic 'l', and 'schwa + r'
              'ɚ', 'ɫ']

# List of IPA diphthongs
ipa_diphthongs = ['aɪ', 'aj', 'aʊ', 'eɪ', 'ej',
                  'oʊ', 'ɔɪ', 'oj', 'ɪə', 'eə', 'ʊə']

# List of IPA consonants
ipa_consonants = [
    'p', 'b', 't', 'd', 'k', 'g', # stops
    'ʧ', 'ʤ', # affricates 
    'f', 'v', 'θ', 'ð', 's', 'z', 'ʃ', 'ʒ', 'h', # fricatives
    'm', 'n', 'ŋ', # nasals
    'l', 'r', 'ɹ', 'w', 'j', 'y' # liquids
    'w', 'j', 'y' # approximants
]

ipa_consonants_SSP = ipa_consonants  # Assuming SSP consonants are the same for this example

def divide_into_syllables(word):
    # Transcribe word to IPA symbols
    ipa_word = ipa.convert(word)
    
    # Initialize syllable list and current syllable
    syllables = []
    current_syllable = ''
    
    # Flag to indicate if we are at the first syllable
    first_syllable = True
    
    # Iterate over each character (i.e., phone unit) in the IPA transcription
    i = 0
    while i < len(ipa_word):
        phone = ipa_word[i]
        
        # Check for diphthongs
        if i < len(ipa_word) - 1 and ipa_word[i:i+2] in ipa_diphthongs:
            if current_syllable and not first_syllable:
                syllables.append(current_syllable)
                current_syllable = ipa_word[i:i+2]
            else:
                current_syllable += ipa_word[i:i+2]
                first_syllable = False
            i += 2
        # Check for vowels
        elif phone in ipa_vowels:
            if current_syllable and not first_syllable:
                syllables.append(current_syllable)
                current_syllable = phone
            else:
                current_syllable += phone
                first_syllable = False
            i += 1
        # Check for consonants
        elif phone in ipa_consonants:
            current_syllable += phone
            i += 1
        else:
            i += 1
    
    # Add the last syllable if it exists
    if current_syllable:
        syllables.append(current_syllable)
    
    return syllables

def divide_into_syllables_SSP(word):
    # Transcribe word to IPA symbols
    ipa_word = ipa.convert(word)
    
    # Initialize syllable list and current syllable
    syllables = []
    current_syllable = ''
    
    # Iterate over each character (i.e., phone unit) in the IPA transcription
    i = 0
    while i < len(ipa_word):
        phone = ipa_word[i]
        
        # Check for diphthongs
        if i < len(ipa_word) - 1 and ipa_word[i:i+2] in ipa_diphthongs:
            current_syllable += ipa_word[i:i+2]
            syllables.append(current_syllable)
            current_syllable = ''
            i += 2
        # Check for vowels
        elif phone in ipa_vowels:
            current_syllable += phone
            syllables.append(current_syllable)
            current_syllable = ''
            i += 1
        # Check for consonants
        elif phone in ipa_consonants_SSP:
            if i < len(ipa_word) - 1 and (ipa_word[i+1] in ipa_vowels or ipa_word[i+1:i+3] in ipa_diphthongs):
                current_syllable += phone
            else:
                if current_syllable:
                    current_syllable += phone
                    syllables.append(current_syllable)
                    current_syllable = ''
                else:
                    if syllables:
                        syllables[-1] += phone
                    else:
                        current_syllable += phone
            i += 1
        else:
            i += 1
    
    # Add the last syllable if it exists
    if current_syllable:
        syllables.append(current_syllable)
    
    return syllables

def count_syllables(word):
    syllables = divide_into_syllables(word)
    return len(syllables)

def orthographic_syllables(word):
    # Use the pyphen library to segment the word orthographically - based on Hunspell Hyphenation Dictionaries for American English
    word2syl = pyphen.Pyphen(lang='en')
    return word2syl.inserted(word).split('-')

# Create a dialog box to enter the words
class CustomDialog(simpledialog.Dialog):
    def body(self, master):
        
        self.geometry("600x370")  # Set the size of the dialog
        self.title("SyllCraft © -  Silva Jr., 2025")
        
        # Set the font size
        font = tkFont.Font(size=14)
        
        tk.Label(master, text="Segment English words into syllables", font=font).pack(pady=10)
        tk.Label(master, text= "Enter words separated by commas", font=tkFont.Font(size=12)).pack()

        # Create a frame for the Text widget and scrollbar
        frame = tk.Frame(master)
        frame.pack(pady=10)
        
        # Create a Text widget with a scrollbar
        self.text = tk.Text(frame, font=font, width=50, height=10, wrap=tk.WORD)
        scrollbar = tk.Scrollbar(frame, command=self.text.yview)
        self.text.config(yscrollcommand=scrollbar.set)
        
        self.text.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
        scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
        
        # Insert default text
        self.text.insert(tk.END, "example, apple, bicycle, pronunciation, aspirin, accent, constitution, applying, cup, attractive")
        return self.text

    def apply(self):
        self.result = self.text.get("1.0", tk.END).strip()

def get_user_input():
    root = tk.Tk()
    root.withdraw()  # Hide the root window
    dialog = CustomDialog(root)
    root.destroy()
    return dialog.result.split(',')

# Get words from user input
words = get_user_input()
data = []

for word in words:
    word = word.strip()
    syllables = divide_into_syllables(word)
    syllable_count = count_syllables(word)
    orth_syllables = orthographic_syllables(word)
    ssp_syllables = divide_into_syllables_SSP(word)
    ssp_syllable_count = len(ssp_syllables)
    data.append([word, orth_syllables, len(orth_syllables), syllables, syllable_count, ssp_syllables, ssp_syllable_count])

print("\n====== Ambisyllabification (Selkirk, 1982, 1984; Clements, 1990; Barbosa, 2006; Ladefoged & Johnson, 2011) ======")
print("")
# Print the results in a tabulated format with centered columns
print(tabulate(data, headers=["Word", "Ortho", "Ortho_Syll", 
                              "Phon", "Phon_Syll", 
                              "SSP-MOP", "SSP-MOP_Syll"],
                              tablefmt="grid", colalign=("center", "center", "center", "center", "center", "center", "center")))