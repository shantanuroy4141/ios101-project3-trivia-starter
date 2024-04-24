//
//  QuizViewController.swift
//  Trivia
//
//  Created by Shantanu Roy on 4/24/24.
//

import UIKit

class QuizViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton1: UIButton!
    @IBOutlet weak var answerButton2: UIButton!
    @IBOutlet weak var answerButton3: UIButton!
    @IBOutlet weak var answerButton4: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!  // This will be used at the end to show the final score
    @IBOutlet weak var currentScoreLabel: UILabel!


    @IBAction func restartQuiz(_ sender: UIButton) {
        currentQuestionIndex = 0
        correctAnswers = 0
        scoreLabel.isHidden = true
        restartButton.isHidden = true
        displayQuestion()
        updateScoreDisplay()  // Reset the score display on restart
    }

    
    // MARK: - Properties
    private var currentQuestion: Question!
    private var questions: [Question]!
    private var currentQuestionIndex = 0
    private var correctAnswers = 0
    private var totalQuestions = 18
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupButtons()
        loadQuestions()
        displayQuestion()
        updateScoreDisplay()  // Initially set the score to 0%
        totalQuestions = questions.count
        // Adjust font size based on screen size
        let fontSize = UIScreen.main.bounds.width > 375 ? 17.0 : 15.0  // Adjust base font size as needed

        categoryLabel.font = categoryLabel.font?.withSize(fontSize)
        questionLabel.font = questionLabel.font?.withSize(fontSize)
        answerButton1.titleLabel?.font = answerButton1.titleLabel?.font?.withSize(fontSize)
        answerButton2.titleLabel?.font = answerButton2.titleLabel?.font?.withSize(fontSize)
        answerButton3.titleLabel?.font = answerButton3.titleLabel?.font?.withSize(fontSize)
        answerButton4.titleLabel?.font = answerButton4.titleLabel?.font?.withSize(fontSize)
    }

    
    private func setupButtons() {
        answerButton1.addTarget(self, action: #selector(didTapAnswer(button:)), for: .touchUpInside)
        answerButton2.addTarget(self, action: #selector(didTapAnswer(button:)), for: .touchUpInside)
        answerButton3.addTarget(self, action: #selector(didTapAnswer(button:)), for: .touchUpInside)
        answerButton4.addTarget(self, action: #selector(didTapAnswer(button:)), for: .touchUpInside)
    }
    
    private func loadQuestions() {
        // Add your questions here following the Question structure
        questions = [
            Question(questionText: "What is the capital of France?",
                     answers: ["London", "Paris", "Berlin", "Rome"],
                     correctAnswer: "Paris",
                     category: .geography),
            Question(questionText: "What year did World War II begin?",
                     answers: ["1914", "1939", "1945", "1989"],
                     correctAnswer: "1939",
                     category: .history),
            Question(questionText: "What is the process of converting a liquid to gas called?",
                     answers: ["Distillation", "Evaporation", "Condensation", "Freezing"],
                     correctAnswer: "Evaporation",
                     category: .science),
            Question(questionText: "Who wrote the novel 'Hamlet'?",
                     answers: ["William Shakespeare", "Jane Austen", "Charles Dickens", "F. Scott Fitzgerald"],
                     correctAnswer: "William Shakespeare",
                     category: .literature),
            Question(questionText: "What is the tallest mountain in the world?",
                     answers: ["Mount Everest", "K2", "Kangchenjunga", "Lhotse"],
                     correctAnswer: "Mount Everest",
                     category: .geography),
            Question(questionText: "What is the largest country in the world by land area?",
                     answers: ["Russia", "Canada", "China", "United States"],
                     correctAnswer: "Russia",
                     category: .geography),
            Question(questionText: "What is the chemical symbol for water?",
                     answers: ["H2O", "CO2", "NaCl", "NH3"],
                     correctAnswer: "H2O",
                     category: .science),
            Question(questionText: "In which year was the first iPhone released?",
                     answers: ["2004", "2007", "2010", "2013"],
                     correctAnswer: "2007",
                     category: .history),
            Question(questionText: "What is the capital of Italy?",
                     answers: ["Rome", "Milan", "Venice", "Florence"],
                     correctAnswer: "Rome",
                     category: .geography),
            Question(questionText: "Who painted the Mona Lisa?",
                     answers: ["Leonardo da Vinci", "Michelangelo", "Sandro Botticelli", "Raphael"],
                     correctAnswer: "Leonardo da Vinci",
                     category: .literature),  // This should be .art
            Question(questionText: "What is the currency of Japan?",
                     answers: ["Yen", "Yuan", "Won", "Korean Won"],
                     correctAnswer: "Yen",
                     category: .geography),
            Question(questionText: "What is the largest ocean on Earth?",
                     answers: ["Pacific Ocean", "Atlantic Ocean", "Indian Ocean", "Arctic Ocean"],
                     correctAnswer: "Pacific Ocean",
                     category: .geography),
            Question(questionText: "What is the name of the largest desert in the world?",
                     answers: ["Sahara Desert", "Gobi Desert", "Australian Desert", "Kalahari Desert"],
                     correctAnswer: "Sahara Desert",
                     category: .geography),
            Question(questionText: "What is the capital of Germany?",
                     answers: ["Berlin", "Munich", "Hamburg", "Cologne"],
                     correctAnswer: "Berlin",
                     category: .geography),
            Question(questionText: "What is the scientific name for humans?",
                     answers: ["Homo sapiens", "Pan troglodytes", "Ursus arctos", "Canis lupus familiaris"],
                     correctAnswer: "Homo sapiens",
                     category: .science),
            Question(questionText: "What is the capital of Australia?",
                     answers: ["Canberra", "Sydney", "Melbourne", "Brisbane"],
                     correctAnswer: "Canberra",
                     category: .geography),
            Question(questionText: "What is the name of the world's longest river?",
                     answers: ["Nile River", "Amazon River", "Yangtze River", "Mississippi River"],
                     correctAnswer: "Nile River",
                     category: .geography),
            Question(questionText: "What is the chemical formula for carbon dioxide?",
                     answers: ["CO2", "H2O", "O2", "CH4"],
                     correctAnswer: "CO2",
                     category: .science),
            // Add more questions here
        ]
    }
    
    private func displayQuestion() {
        guard currentQuestionIndex < questions.count else {
            showFinalScore()
            return
        }
        currentQuestion = questions[currentQuestionIndex]
        categoryLabel.text = currentQuestion.category.rawValue
        questionLabel.text = currentQuestion.questionText
        setButtonTitles(answers: currentQuestion.answers)
        progressLabel.text = "Question \(currentQuestionIndex + 1) of \(totalQuestions)"
        currentQuestionIndex += 1
    }

    
    private func setButtonTitles(answers: [String]) {
        answerButton1.setTitle(answers[0], for: .normal)
        answerButton2.setTitle(answers[1], for: .normal)
        answerButton3.setTitle(answers[2], for: .normal)
        answerButton4.setTitle(answers[3], for: .normal)
    }
    
    @objc func didTapAnswer(button: UIButton) {
        guard let selectedAnswer = button.title(for: .normal) else { return }
        if selectedAnswer == currentQuestion.correctAnswer {
            correctAnswers += 1
            print("Correct!")
        } else {
            print("Incorrect. The correct answer is \(currentQuestion.correctAnswer).")
        }

        updateScoreDisplay()  // Update the score display immediately after answering

        if currentQuestionIndex == totalQuestions {
            showFinalScore()
        } else {
            displayQuestion()
        }
    }

    private func updateScoreDisplay() {
        let scorePercentage = calculateScore()
        currentScoreLabel.text = "Current Score: \(String(format: "%.2f", scorePercentage))%"
    }

    
    private func calculateScore() -> Double {
      return Double(correctAnswers) / Double(totalQuestions) * 100.0
    }
    
    private func showFinalScore() {
        let score = calculateScore()
        scoreLabel.text = "You've completed the quiz! Your score is \(score)%."
        scoreLabel.isHidden = false
        restartButton.isHidden = false
        print("You finished! Your score is \(score)%.")
    }
    
}



struct Question {
    let questionText: String
    let answers: [String]
    let correctAnswer: String
    let category: QuestionCategory
}

enum QuestionCategory: String, CaseIterable {
    case geography = "Geography"
    case history = "History"
    case science = "Science"
    case literature = "Literature"
    // Add more categories as needed
}
