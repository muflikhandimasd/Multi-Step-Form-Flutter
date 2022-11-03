import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // !TEXTCONTROLLER
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final address = TextEditingController();
  final postCode = TextEditingController();
  // !TEXTCONTROLLER

  //  !CONDITION
  int currentStep = 0;
  bool isCompleted = false;
  //  !CONDITION

  @override
  Widget build(BuildContext context) {
    // !LIST STEP
    List<Step> getSteps = [
      Step(
        state: currentStep > 0 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 0,
        title: const Text('Account'),
        content: Column(
          children: [
            TextFormField(
              controller: firstName,
              decoration: const InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: lastName,
              decoration: const InputDecoration(labelText: 'Last Name'),
            ),
          ],
        ),
      ),
      Step(
        state: currentStep > 1 ? StepState.complete : StepState.indexed,
        isActive: currentStep >= 1,
        title: const Text('Address'),
        content: Column(
          children: [
            TextFormField(
              controller: address,
              decoration: const InputDecoration(labelText: 'Address'),
            ),
            TextFormField(
              controller: postCode,
              decoration: const InputDecoration(labelText: 'Post Code'),
            ),
          ],
        ),
      ),
      Step(
          isActive: currentStep >= 2,
          title: const Text('Complete'),
          content: Column(
            children: [
              Text('First Name : ${firstName.text}'),
              const SizedBox(
                height: 10,
              ),
              Text('Last Name : ${lastName.text}'),
              const SizedBox(
                height: 10,
              ),
              Text('Addrees : ${address.text}'),
              const SizedBox(
                height: 10,
              ),
              Text('Post Code : ${postCode.text}'),
              const SizedBox(
                height: 10,
              ),
            ],
          )),
    ];

    // !LIST STEP

    //  !LAST STEP
    int lastStep = getSteps.length - 1;
    bool inLast = currentStep == lastStep;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Multi Step Form',
        ),
        centerTitle: true,
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: Colors.red)),
        child: isCompleted
            ? buildCompleted()
            : Stepper(
                type: StepperType.horizontal,
                currentStep: currentStep,
                steps: getSteps,
                onStepTapped: (step) => setState(() {
                  currentStep = step;
                }),
                onStepContinue: () {
                  if (!inLast) {
                    setState(() {
                      currentStep += 1;
                    });
                  }
                  return;
                },
                onStepCancel: () {
                  if (currentStep > 0) {
                    setState(() {
                      currentStep -= 1;
                    });
                  }
                  return;
                },
                controlsBuilder: (context, details) {
                  return Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Row(
                      children: [
                        Expanded(
                            child: ElevatedButton(
                          onPressed: inLast
                              ? () => setState(() => isCompleted = true)
                              : details.onStepContinue,
                          child: Text(inLast ? 'Confirm' : 'Next'),
                        )),
                        if (currentStep != 0)
                          const SizedBox(
                            width: 30,
                          ),
                        if (currentStep != 0)
                          Expanded(
                              child: ElevatedButton(
                            onPressed: details.onStepCancel,
                            child: const Text('BACK'),
                          )),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget buildCompleted() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.account_circle_rounded,
              size: 200,
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              'SUCCESS',
              style: TextStyle(fontSize: 30),
            ),
            ElevatedButton(
                onPressed: () {
                  setState(() {
                    isCompleted = false;
                    currentStep = 0;
                    firstName.clear();
                    lastName.clear();
                    address.clear();
                    postCode.clear();
                  });
                },
                child: const Text('Reset'))
          ],
        ),
      ),
    );
  }
}
