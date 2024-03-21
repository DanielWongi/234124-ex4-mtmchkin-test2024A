#include <fstream>
#include <iostream>
#include <string>
#include "Mtmchkin.h"
#include "utilities.h"

using std::cerr;
using std::cout;
using std::endl;
using std::ifstream;
using std::ofstream;
using std::string;

static const int REQUIRED_ARGS = 4;

void simulateGame(const string& deckPath, const string& playersPath, const string& outputPath) {
    // Redirect cout to output file
    ofstream outFile(outputPath);
    auto coutBuf = cout.rdbuf(); // Save old buffer
    cout.rdbuf(outFile.rdbuf());

    try {
        Mtmchkin game(deckPath, playersPath);
        game.play();
    } catch (const std::exception& e) {
        cout << e.what() << endl;
    }

    // Restore original cout buffer
    cout.rdbuf(coutBuf);
}

int main(int argc, char** argv) {
    if (argc != REQUIRED_ARGS) {
        cerr << "Invalid number of arguments" << endl;
        cerr << "Usage: " << argv[0] << " <deck_file_path> <players_file_path> <output_file_path>" << endl;
        return 1;
    }

    string deckPath = argv[1];
    string playersPath = argv[2];
    string outputPath = argv[3];

    simulateGame(deckPath, playersPath, outputPath);

    return 0;
}
