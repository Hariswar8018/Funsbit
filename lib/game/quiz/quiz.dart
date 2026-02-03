import 'package:earning_app/ads/ads_helper.dart';
import 'package:earning_app/game/quiz/firestore%20service.dart';
import 'package:earning_app/game/quiz/gemini.dart';
import 'package:earning_app/global/color.dart';
import 'package:earning_app/global/notify.dart' show Send;
import 'package:earning_app/global/widget.dart';
import 'package:earning_app/login/bloc/bloc.dart';
import 'package:earning_app/model/quiz.dart';
import 'package:earning_app/navigation/user/service/transaction.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  List<QuizQuestion> quiz = [];
  NativeAd? _nativeAd;
  NativeAd? _nativeAd1;
  bool _isNativeLoaded = false;

  void loadNativeAd() {

    _nativeAd = NativeAd(
      adUnitId: AdHelper.getNative(1),

      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeLoaded = true;
          });

          print('✅ Native Loaded');
        },

        onAdFailedToLoad: (ad, error) {

          ad.dispose();

          print('❌ Native Failed: $error');
        },
      ),
    );
    _nativeAd1 = NativeAd(
      adUnitId: AdHelper.getNative(0),

      factoryId: 'listTile',
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isNativeLoaded = true;
          });

          print('✅ Native Loaded');
        },

        onAdFailedToLoad: (ad, error) {

          ad.dispose();

          print('❌ Native Failed: $error');
        },
      ),
    );
    _nativeAd1!.load();

    _nativeAd!.load();
  }
  Widget nativeAdWidget() {

    if (!_isNativeLoaded || _nativeAd == null) {
      return const SizedBox();
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(8),

      child: AdWidget(ad: _nativeAd!),
    );
  }
  Widget nativeAdWidget1() {

    if (!_isNativeLoaded || _nativeAd1 == null) {
      return const SizedBox();
    }

    return Container(
      height: 300,
      padding: const EdgeInsets.all(8),

      child: AdWidget(ad: _nativeAd1!),
    );
  }
  int current = 0;
  int correct = 0;
  int wrong = 0;

  bool loading = true;
  bool answered = false;
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    loadNativeAd();
    loadQuiz();
  }

  Future<void> loadQuiz() async {
    debugPrint("🟡 loadQuiz() started");

    try {
      debugPrint("🟢 Calling Gemini...");
      final geminiQuiz = await FirebaseGeminiService.fetchQuiz();
      debugPrint("🟢 Gemini returned ${geminiQuiz.length}");

      if (geminiQuiz.isNotEmpty) {
        quiz = geminiQuiz;
        await FirestoreService.saveQuiz(geminiQuiz);
      } else {
        debugPrint("🟠 Gemini empty → Firestore fallback");
        quiz = await FirestoreService.fetchRandomQuiz();
      }
    } catch (e, st) {
      debugPrint("🔴 Gemini error: $e");
      debugPrint(st.toString());

      quiz = await FirestoreService.fetchRandomQuiz();
    }

    setState(() => loading = false);
  }



  void selectAnswer(int index) {
    if (answered) return;

    setState(() {
      answered = true;
      selectedIndex = index;

      if (index == quiz[current].correctIndex) {
        correct++;
      } else {
        wrong++;
      }
    });

    Future.delayed(const Duration(seconds: 1), nextQuestion);
  }

  void nextQuestion() {
    if (current < quiz.length - 1) {
      setState(() {
        current++;
        answered = false;
        selectedIndex = -1;
      });
    } else {
      reward(correct);
    }
  }
  Future<void> giveUserReward(int coinss) async {

    await TransactionService.updateTransaction(
        id: DateTime.now().toString(), name: 'Quiz Game Win', coins: coinss,
        status: 'Credited', debit: false, userId: GlobalUser.user.id
    );
    await Send.addcoins(context, coinss);
  }
  Future<void> reward(int correctAnswers) async {
    final int coinsWon = correctAnswers * 10;

   await giveUserReward(coinsWon);

    // 2️⃣ Show result dialog
    if (!mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        title: const Text("🎉 Quiz Completed"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Correct Answers: $correctAnswers / ${quiz.length}"),
            const SizedBox(height: 8),
            Text(
              "You won 🪙 $coinsWon coins!",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              restartQuiz();
            },
            child: const Text("Restart"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // go back / close quiz
            },
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
  void restartQuiz() {
    setState(() {
      current = 0;
      correct = 0;
      wrong = 0;
      answered = false;
      selectedIndex = -1;
      loading = true;
      quiz.clear();
    });

    loadQuiz(); // fetch new quiz
  }



  Color optionColor(int index) {
    if (!answered) return Colors.blue;

    if (index == quiz[current].correctIndex) {
      return Colors.green;
    }

    if (index == selectedIndex) {
      return Colors.red;
    }

    return Colors.blue;
  }


  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    if (loading) {
      return  Scaffold(
        backgroundColor: GlobalColor.gameback,
        body: Column(
          children: [
            GlobalWidget.appbar(context, "Quiz Game"),
            const SizedBox(height: 10),
            Spacer(),
            CircularProgressIndicator(
              color:Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("Igniting the Quiz Engine",style: TextStyle(fontWeight: FontWeight.w800,color: Colors.white),),
            ),
            nativeAdWidget(),
            Spacer()
          ],
        ),
      );
    }
    if (!loading && quiz.isEmpty) {
      return Scaffold(
        backgroundColor: GlobalColor.gameback,
        body: Center(
          child: Text(
            "Quiz unavailable.\nPlease try again later.",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    }

    final q = quiz[current];
    if (quiz.isEmpty) {
      return Scaffold(
        backgroundColor: GlobalColor.gameback,
        body: Center(
          child: Text(
            "No quiz available.\nTry again later.",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: GlobalColor.gameback,
      body: Column(
        children: [
          GlobalWidget.appbar(context, "Quiz Game"),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                width: w/3+40,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.touch_app_outlined),
                    Text("Correct : ${correct}/10",
                      style: TextStyle(fontWeight: FontWeight.w900),),
                  ],
                ),
              ),
              Container(
                width: w/3+40,
                height: 50,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15)
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.diamond_outlined),
                    Text(" Coins : ${correct*10}",
                      style: TextStyle(fontWeight: FontWeight.w900),),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              q.question,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
          ),

          const SizedBox(height: 20),

          ...List.generate(q.options.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 8),
              child: Container(
                width: double.infinity,
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: optionColor(index),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () => selectAnswer(index),
                  child: Text(
                    q.options[index],
                    style: const TextStyle(fontSize: 16,color: Colors.white),
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 20,),
          nativeAdWidget1(),
        ],
      ),
    );
  }
}
