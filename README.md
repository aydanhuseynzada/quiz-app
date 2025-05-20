# quiz-app
This project built using Flutter and Visual Studio Code.
Created by Aygun Najafli, Aydan Huseynzada, Amina Ahmadova
This is a complete Flutter app for a quiz game. Here's a short breakdown of the code:

1. **`main.dart`**:

   * Initializes the app and sets the status bar to transparent.
   * Uses `MaterialApp` to define the app's theme, including colors, fonts, and button styles.
   * Sets the `HomePage` as the starting screen.

2. **`HomePage.dart`**:

   * Displays a list of quizzes loaded from a JSON file.
   * Each quiz has a title, description, and a button to start the quiz.

3. **`QuizPage.dart`**:

   * Displays questions with multiple-choice options.
   * Tracks the user's answers and allows navigation to the results page after completing all questions.

4. **`ResultPage.dart`**:

   * Shows the user's score, feedback, and a confetti animation if they score high.
   * Provides options to restart the quiz, go back to the home page, or view wrong answers.

5. **`WrongAnswersPage.dart`**:

   * Displays the questions the user got wrong along with their selected and correct answers.

6. **`QuizModel.dart`**:

   * Defines models for the quiz, questions, and options, including methods for creating these objects from JSON data.

7. **`QuizDataLoader.dart`**:

   * Loads quiz data from a local JSON file and returns a list of quizzes.

In short, this app allows users to take a quiz, check their score, and see the answers they got wrong, all wrapped in a colorful, interactive interface.
