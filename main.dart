import 'package:flutter/material.dart';

void main() {
  runApp(const TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  const TipCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip Calculator',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF176B5B),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF5F7F6),
      ),
      home: const TipCalculatorPage(),
    );
  }
}

class TipCalculatorPage extends StatefulWidget {
  const TipCalculatorPage({super.key});

  @override
  State<TipCalculatorPage> createState() => _TipCalculatorPageState();
}

class _TipCalculatorPageState extends State<TipCalculatorPage> {
  double bill = 0;
  double tipPercent = 10;
  int people = 1;

  double get tip => bill * tipPercent / 100;
  double get total => bill + tip;
  double get tipPerPerson => tip / people;
  double get totalPerPerson => total / people;

  void _updateBill(String value) {
    final parsedBill = double.tryParse(value);
    setState(() {
      bill = parsedBill != null && parsedBill.isFinite && parsedBill > 0
          ? parsedBill
          : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tip Calculator'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Text(
                  'Split the bill, not the guesswork.',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                Text(
                  'Enter your bill and choose how much to tip.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: const InputDecoration(
                            labelText: 'Bill amount',
                            border: OutlineInputBorder(),
                            hintText: 'e.g. 1000',
                          ),
                          onChanged: _updateBill,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tip percentage',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              '${tipPercent.round()}%',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        Slider(
                          value: tipPercent,
                          min: 0,
                          max: 30,
                          divisions: 30,
                          label: '${tipPercent.round()}%',
                          onChanged: (value) {
                            setState(() => tipPercent = value);
                          },
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Text(
                              'People',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const Spacer(),
                            IconButton(
                              tooltip: 'Remove one person',
                              onPressed: people > 1
                                  ? () => setState(() => people--)
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            SizedBox(
                              width: 36,
                              child: Text(
                                '$people',
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                            ),
                            IconButton(
                              tooltip: 'Add one person',
                              onPressed: () => setState(() => people++),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'EACH PERSON PAYS',
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(
                                letterSpacing: 1.2,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          totalPerPerson.toStringAsFixed(2),
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(),
                        _ResultRow(
                          label: 'Bill total',
                          value: bill.toStringAsFixed(2),
                        ),
                        const SizedBox(height: 12),
                        _ResultRow(
                          label: 'Tip total',
                          value: tip.toStringAsFixed(2),
                        ),
                        const SizedBox(height: 12),
                        _ResultRow(
                          label: 'Tip per person',
                          value: tipPerPerson.toStringAsFixed(2),
                        ),
                        const SizedBox(height: 12),
                        _ResultRow(
                          label: 'Total per person',
                          value: totalPerPerson.toStringAsFixed(2),
                          emphasized: true,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontWeight: emphasized ? FontWeight.bold : FontWeight.normal,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
