#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counter for failed tests and string to hold failed test numbers
FAILED_TESTS=0
FAILED_TEST_NUMBERS=""

# Number of tests to run, can be increased as needed
TESTS_TO_RUN=1232

echo "
     XXXXXXXXY          XXXXXXX
        XXXXX            XXXXX
        XXXXX           XXXXX   X             X                                      XX
        XXXXXX         XXXXXX   XXXXXXXXXXXXXXX XXXXXXX         XXXXXX     XXXXXXXXXXX XXXXXX     XXXXXX  XXXXXW  XXXXXXXXXXXXYXXXXXXX     XXXXXX
        XXXXXXX       XXXXXXX   X    WXXX     X   XXXXX         XXXX     XXXX       XX  XXXX        XXX    XXXX   XXX     XXX    XXXXXX      XXX
        XX XXXXX     XXX XXXXY       XXXX          XXXXX       XXXXX   XXXXX         X  YXXX       XXXX    XXXW  XX       XXX    XXX XXXX    XXY
        XX  XXXXX   XXX   XXXX       YXXX         XX XXXY     XX XXX   XXXX             YXXX       WXXX    XXXWXXX        XXX    XXX  XXXX   XX
       XXX   XXXXX XXX    XXXX       YXXX         XX  XXXY   XX  XXXX XXXX               XXXXXXXXXXXXXX    XXXXXXXX       XXXX   XXX   XXXX  XXX
       XXX    XXXX XX     XXXX       YXXX         XX   XXXX XX   XXXX XXXX              XXXX        XXX    XXX  XXXX      XXX    XX      XXXXXX
       XXX     XXXXX      XXXX       YXXX         XX   XXXXXX    XXXX  XXXX          X   XXX       XXXX    XXXZ  XXXX     XXXX   XX       XXXXX
       XXX     XXXXX      XXXX       YXXX         XX    XXXXY    XXXX   XXXXX      XXX  WXXX       XXXX    XXX     XXXX   XXXX   XX        XXXX
     XXXXXXX    XXX     XXXXXXX     XXXXXXX     XXXXX    XXX    XXXXXX   WXXXXXXXXXXXX WXXXXX     XXXXXXX XXXXX     XXXX XXXXX YXXXXX        XX
                 Y                                        X                          XX                               XXXX                    X
                                                                                                                        XXX         X
                                                                                                                          XXXXXXXXX
"

# Main loop for running tests
for ((testNumber=0; testNumber<=TESTS_TO_RUN; testNumber++)); do
    inFile="fileTests/inFiles/test${testNumber}.in"
    deckFile="fileTests/inFiles/test${testNumber}.deck"
    resultFile="fileTests/outFiles/test${testNumber}.result"
    expectedFile="fileTests/outFiles/test${testNumber}.out"
    valgrindLogFile="fileTests/inFiles/test${testNumber}.valgrind_log"

    echo "Running test $testNumber >>>"

    # Run the game simulation and output results to a file
    ./FileTester "$deckFile" "$inFile" "$resultFile"

    # Compare the generated result with the expected result
    if diff "$expectedFile" "$resultFile" > /dev/null; then
        echo -e "Game Simulation: ${GREEN}pass${NC},"
    else
        echo -e "Game Simulation: ${RED}fail${NC}"
        ((FAILED_TESTS++))
        FAILED_TEST_NUMBERS+="$testNumber \n"
    fi

    # Run Valgrind to check for memory leaks
    valgrind --log-file="$valgrindLogFile" --leak-check=full ./FileTester "$inFile" "$deckFile" "fileTests/outFiles/test${testNumber}.vresult" > /dev/null 2>&1

    # Clean up the Valgrind result file as it's no longer needed
    rm -f "fileTests/outFiles/test${testNumber}.vresult"

    # Check Valgrind's output for the absence of memory leaks
    if grep -q "ERROR SUMMARY: 0 errors" "$valgrindLogFile"; then
        echo -e "Memory Leak: ${GREEN}pass${NC}\n"
    else
        echo -e "Memory Leak: ${RED}fail${NC}\n"
        cat "$valgrindLogFile"
        ((FAILED_TESTS++))
        FAILED_TEST_NUMBERS+="$testNumber "
    fi

    # Remove Valgrind log file after checking
    rm -f "$valgrindLogFile"
done

# Define colors
GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m' # Purple color
NC='\033[0m' # No Color


# Final output, showing whether all tests passed or some failed
if [ $FAILED_TESTS -eq 0 ]; then
    echo -e "${GREEN}
  __  __ _____ __  __  ____ _   _ _  _____ _   _
 |  \/  |_   _|  \/  |/ ___| | | | |/ |_ _| \ | |
 | |\/| | | | | |\/| | |   | |_| | ' / | ||  \| |
 | |  | | | | | |  | | |___|  _  | . \ | || |\  |
 |_|  |_| |_| |_|  |_|\____|_| |_|_|\_|___|_| \_|
        ┏┓┓ ┓   ┏┳┓┏┓┏┓┏┳┓┏┓  ┏┓┏┓┏┓┏┓┏┓┳┓
        ┣┫┃ ┃    ┃ ┣ ┗┓ ┃ ┗┓  ┃┃┣┫┗┓┗┓┣ ┃┃
        ┛┗┗┛┗┛   ┻ ┗┛┗┛ ┻ ┗┛  ┣┛┛┗┗┛┗┛┗┛┻┛
            ┓ ┏┓ ┏┓ ┏ ┓ ┏┏┓┳┓┏┓┳ ┳┏┓
            ┃┃┃┃┃┃┃┃┃ ┃┃┃┃┃┃┃┃┓┃ ┃┃┃
            ┗┻┛┗┻┛┗┻┛•┗┻┛┗┛┛┗┗┛┻•┻┗┛
${NC}"
else
    echo -e "${RED}
     XXXXXXXXY          XXXXXXX
        XXXXX            XXXXX
        XXXXX           XXXXX   X             X                                      XX
        XXXXXX         XXXXXX   XXXXXXXXXXXXXXX XXXXXXX         XXXXXX     XXXXXXXXXXX XXXXXX     XXXXXX  XXXXXW  XXXXXXXXXXXXYXXXXXXX     XXXXXX
        XXXXXXX       XXXXXXX   X    WXXX     X   XXXXX         XXXX     XXXX       XX  XXXX        XXX    XXXX   XXX     XXX    XXXXXX      XXX
        XX XXXXX     XXX XXXXY       XXXX          XXXXX       XXXXX   XXXXX         X  YXXX       XXXX    XXXW  XX       XXX    XXX XXXX    XXY
        XX  XXXXX   XXX   XXXX       YXXX         XX XXXY     XX XXX   XXXX             YXXX       WXXX    XXXWXXX        XXX    XXX  XXXX   XX
       XXX   XXXXX XXX    XXXX       YXXX         XX  XXXY   XX  XXXX XXXX               XXXXXXXXXXXXXX    XXXXXXXX       XXXX   XXX   XXXX  XXX
       XXX    XXXX XX     XXXX       YXXX         XX   XXXX XX   XXXX XXXX              XXXX        XXX    XXX  XXXX      XXX    XX      XXXXXX
       XXX     XXXXX      XXXX       YXXX         XX   XXXXXX    XXXX  XXXX          X   XXX       XXXX    XXXZ  XXXX     XXXX   XX       XXXXX
       XXX     XXXXX      XXXX       YXXX         XX    XXXXY    XXXX   XXXXX      XXX  WXXX       XXXX    XXX     XXXX   XXXX   XX        XXXX
     XXXXXXX    XXX     XXXXXXX     XXXXXXX     XXXXX    XXX    XXXXXX   WXXXXXXXXXXXX WXXXXX     XXXXXXX XXXXX     XXXX XXXXX YXXXXX        XX
                 Y                                        X                          XX                               XXXX                    X
                                                                                                                        XXX         X
                                                                                                                          XXXXXXXXX
    "
    echo -e "\n${RED}Failed $FAILED_TESTS tests.${NC}"
    echo -e "Failed tests: \n${PURPLE}${FAILED_TEST_NUMBERS}${NC}\n"
    echo "To see the differences for a failed test, use the diff.sh script. For example:"
    echo -e "${BLUE}./diff.sh <test_number>${NC}"
    echo "Make sure you have given execute permission to the script before using it. Run the following command to do so:"
    echo -e "${BLUE}chmod +x diff.sh${NC}"
fi
echo "Increase TESTS_TO_RUN in tester.sh to run more tests (up to 1232)."