#!/bin/bash

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Counter for failed tests and string to hold failed test numbers
FAILED_TESTS=0
FAILED_TEST_NUMBERS=""

# Number of tests to run, can be increased as needed
TESTS_TO_RUN=1231

# Main loop for running tests
for i in fileTests/inFiles/test*.in; do
    testNumber=${i//[^0-9]/} # Extracting test number from filename

    if [[ $testNumber -gt $TESTS_TO_RUN ]]; then
        continue
    fi

    echo "Running test $testNumber >>>"

    # Run the game simulation and output results to a file
    ./FileTester "fileTests/inFiles/test${testNumber}.deck" "$i" "fileTests/outFiles/test${testNumber}.result"

    # Compare the generated result with the expected result
    if diff "fileTests/outFiles/test${testNumber}.out" "fileTests/outFiles/test${testNumber}.result" > /dev/null; then
        echo -e "Game Simulation: ${GREEN}pass${NC},"
    else
        echo -e "Game Simulation: ${RED}fail${NC}"
        ((FAILED_TESTS++))
        FAILED_TEST_NUMBERS+="$testNumber \n"
    fi

    # Run Valgrind to check for memory leaks
    valgrindLogFile="fileTests/inFiles/test${testNumber}.valgrind_log"
    valgrind --log-file="$valgrindLogFile" --leak-check=full ./FileTester "$i" "fileTests/inFiles/test${testNumber}.deck" "fileTests/outFiles/test${testNumber}.vresult" > /dev/null 2>&1

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
    echo -e "\n${RED}Failed $FAILED_TESTS tests.${NC}"
    echo -e "Failed tests: \n${PURPLE}${FAILED_TEST_NUMBERS}${NC}\n"
    echo "To see the differences for a failed test, use the diff.sh script. For example:"
    echo -e "${BLUE}./diff.sh <test_number>${NC}"
    echo "Make sure you have given execute permission to the script before using it. Run the following command to do so:"
    echo -e "${BLUE}chmod +x diff.sh${NC}"
fi
echo "Increase TESTS_TO_RUN in tester.sh to run more tests (up to 1231)."
