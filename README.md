# Tubes2-IF3170

## How to run

1. Download CLIPSIDE from [here](https://sourceforge.net/projects/clipsrules/)
2. Clone the repository using `git clone https://github.com/airathalca/Tubes2-IF3170.git`
3. Set clips path to file directory
4. This program use complexity strategy for the resolution conflicts so run `(set-strategy complexity)` to change the resolution strategy and make sure the next printed out text is 'complexity'
5. Make sure you are on a clear state (no leftover facts), run `(clear)` to clean the CLIPS
6. Load the file using `(load "diagnosis.clp")`
7. Reset the clp using `(reset)`
8. Finally run the expert system using `(run)`
