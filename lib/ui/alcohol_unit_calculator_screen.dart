import 'package:alcohol_unit_calculator/services/unit_calculator.dart';
import 'package:alcohol_unit_calculator/services/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final volumeProvider = StateProvider<double>((ref) => 25);
final percentAbvProvider = StateProvider<double>((ref) => 40);

final unitCalculatorProvider =
    StateProvider<UnitCalculator>((ref) => UnitCalculator());

final unitsProvider = Provider<String>((ref) {
  final volume = ref.watch(volumeProvider);
  final percentAbv = ref.watch(percentAbvProvider);
  final unitCalculator = ref.watch(unitCalculatorProvider);
  try {
    final units =
        unitCalculator.unitsForDrink(volumeMl: volume, percentAbv: percentAbv);
    return toStringWithoutTrailingZeros(units);
  } catch (e) {
    return '';
  }
});

class AlcoholUnitCalculatorScreen extends StatelessWidget {
  const AlcoholUnitCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: FocusTraversalGroup(
          policy: OrderedTraversalPolicy(),
          descendantsAreFocusable: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Container(
                alignment: Alignment.center,
                height: 50,
                child: const Text(
                  'Alchohol Unit Calculator',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const Divider(),
              const VolumeInput(order: 1),
              const Divider(),
              const PercentAbvInput(order: 2),
              const Divider(),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                height: 30,
                child: const Text(
                  'Units:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              const UnitDisplay(),
            ],
          ),
        ),
      ),
    );
  }
}

class InputWithCommonOptions<T> extends HookConsumerWidget {
  const InputWithCommonOptions({
    super.key,
    required this.label,
    required this.provider,
    required this.options,
    required this.optionLabels,
    required this.parseText,
    required this.renderText,
    required this.order,
  });

  final String label;
  final StateProvider<T> provider;
  final List<T> options;
  final List<String> optionLabels;
  final int order;

  /// Function to parse a selected option (or text input) back to the
  /// desired value. If this function throws, the [provider] value will not
  /// be updated.
  final T Function(String) parseText;

  /// Function to render the value as a string inside the [TextField].
  final String Function(T) renderText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = useTextEditingController(
      text: renderText(ref.read(provider)),
    );
    useEffect(() {
      listener() {
        try {
          ref.read(provider.notifier).state = parseText(controller.text);
        } on FormatException {
          // ignore
        }
      }

      controller.addListener(listener);
      return () => controller.removeListener(listener);
    });
    debugPrint(
        '$label: text field gets ${order * 2}, grid gets ${order * 2 + 1}');
    return Row(
      children: [
        Expanded(
          flex: 10,
          child: FocusTraversalOrder(
            order: NumericFocusOrder(order * 1.0),
            child: TextField(
              controller: controller,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
              ],
              decoration: InputDecoration(
                helperText: label,
                helperStyle: const TextStyle(fontSize: 20),
                suffixIcon: IconButton(
                  onPressed: controller.clear,
                  icon: const Icon(Icons.clear),
                ),
              ),
              style: const TextStyle(fontSize: 50),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 7,
          child: FocusTraversalOrder(
            order: NumericFocusOrder(order + 100000.0),
            child: GridView.count(
              crossAxisCount: 2,
              primary: false,
              shrinkWrap: true,
              children: options.asMap().entries.map(
                (entry) {
                  final idx = entry.key;
                  final value = entry.value;
                  final label = optionLabels[idx];
                  return Container(
                    padding: const EdgeInsets.all(5),
                    width: 30,
                    height: 30,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.text = renderText(value);
                      },
                      child: Text(label),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
      ],
    );
  }
}

class VolumeInput extends StatelessWidget {
  const VolumeInput({super.key, required this.order});
  final int order;

  @override
  Widget build(BuildContext context) {
    return InputWithCommonOptions<double>(
      label: 'Volume (ml)',
      provider: volumeProvider,
      options: const [330, 440, 500, 568],
      optionLabels: const ['330ml', '440ml', '500ml', 'Pint'],
      parseText: (text) => double.parse(text),
      renderText: toStringWithoutTrailingZeros,
      order: order,
    );
  }
}

class PercentAbvInput extends StatelessWidget {
  const PercentAbvInput({super.key, required this.order});
  final int order;

  @override
  Widget build(BuildContext context) {
    return InputWithCommonOptions<double>(
      label: 'Percent ABV',
      provider: percentAbvProvider,
      options: const [5, 6, 7, 9],
      optionLabels: const ['5%', '6%', '7%', '9%'],
      parseText: (text) => double.parse(text),
      renderText: toStringWithoutTrailingZeros,
      order: order,
    );
  }
}

class UnitDisplay extends ConsumerWidget {
  const UnitDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unitString = ref.watch(unitsProvider);
    return Container(
      alignment: Alignment.center,
      height: 70,
      child: Text(
        unitString,
        style: const TextStyle(fontSize: 70),
      ),
    );
  }
}
