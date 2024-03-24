![Header Image](https://i.imgur.com/5IuOeH6.png)
# 234124-ex4-mtmchkin-test2024A
1. **First**, create a `test` folder in the root directory of the project. 

## Project Structure

Ensure to create a `test` folder in the root directory of your project. The project files should **not** be inside the `test` folder. Below is the recommended directory structure:

```plaintext
project/
├── Cards/
│   ├── Card.cpp
│   └── Card.h
├── Players/
│   ├── Player.cpp
│   └── Player.h
├── Mtmchkin.cpp
├── Mtmchkin.h
└── test/
    ├── makefileMtmchkinTests
    ├── testMain.cpp
    ├── tester.sh
    ├── diff.sh
    └── fileTests/
```
This structure ensures that your project files and test directory are organized correctly within your project's root directory.

2. Extract the zip file inside the `test` folder.
3. Navigate to the `test` directory and execute the 3 commands (**second command if needed**):
```bash
make -f makefileMtmchkinTests
```
```bash
chmod +x tester.sh
```
```bash
./tester.sh
```


## Diagnosing Failed Tests with diff.sh
If you encounter any failed tests, the diff.sh script is here to help. This utility allows you to compare the expected and actual outputs of a test, providing clarity on what went wrong.
```bash
chmod +x diff.sh
```
```bash
./diff.sh <test_number>
```
This command will display any discrepancies, aiding in your debugging process.
No Differences Found? If diff.sh does not show any differences, it suggests that the test's expected and actual results match. The failure may be due to external factors or configurations.
![Alt text](https://i.imgur.com/071tfcv.png)
