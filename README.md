![Header Image](https://i.imgur.com/l9dk1ZL.png)
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

