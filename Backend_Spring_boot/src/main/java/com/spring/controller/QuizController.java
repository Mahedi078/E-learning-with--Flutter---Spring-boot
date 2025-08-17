package com.spring.controller;

import com.spring.model.Quiz;
import com.spring.dao.QuizRepository;
import com.spring.model.Question;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;

@RestController
@RequestMapping("/api/quizzes")
@CrossOrigin(origins = "*")
public class QuizController {

    @Autowired
    private QuizRepository quizRepository;



    // 1. Get all quizzes
    @GetMapping
    public List<Quiz> getAllQuizzes() {
        return quizRepository.findAll();
    }

    // 2. Get quiz by ID
    @GetMapping("/{id}")
    public ResponseEntity<Quiz> getQuiz(@PathVariable Long id) {
        Optional<Quiz> optionalQuiz = quizRepository.findById(id);
        if (!optionalQuiz.isPresent()) {
            return ResponseEntity.notFound().build();
        }
        return ResponseEntity.ok(optionalQuiz.get());
    }

    // 3. Create a new quiz (with questions)
    @PostMapping
    public ResponseEntity<Quiz> createQuiz(@RequestBody Quiz quiz) {
        List<Question> questions = quiz.getQuestions();
        if (questions != null) {
            for (Question question : questions) {
                question.setQuiz(quiz);
            }
        } else {
            quiz.setQuestions(new ArrayList<>());
        }
        Quiz saved = quizRepository.save(quiz);
        return ResponseEntity.ok(saved);
    }

    // 4. Submit quiz answers
    // Accepts map with string keys (questionId as string) to avoid JSON parsing errors
    @PostMapping("/{id}/submit")
    public ResponseEntity<?> submitQuiz(@PathVariable Long id, @RequestBody Map<String, String> answers) {
        Optional<Quiz> optionalQuiz = quizRepository.findById(id);
        if (!optionalQuiz.isPresent()) {
            return ResponseEntity.notFound().build();
        }

        Quiz quiz = optionalQuiz.get();
        List<Question> questions = quiz.getQuestions();
        if (questions == null || questions.isEmpty()) {
            return ResponseEntity.badRequest().body("Quiz has no questions.");
        }

        int total = questions.size();
        int correct = 0;

        for (Question q : questions) {
            String qidStr = q.getId() != null ? q.getId().toString() : null;
            if (qidStr == null) continue;
            String submittedAnswer = answers.get(qidStr);
            if (submittedAnswer != null && q.getCorrectOption() != null
                && q.getCorrectOption().equalsIgnoreCase(submittedAnswer)) {
                correct++;
            }
        }

        Map<String, Object> result = new HashMap<>();
        result.put("correct", correct);
        result.put("total", total);
        result.put("message", "You scored " + correct + " out of " + total);

        return ResponseEntity.ok(result);
    }
}
