import 'dart:async';

import 'package:dstokenbam_example_new/src/provider/ds_token_bam_provider.dart';
import 'package:dstokenbam_example_new/src/theme/theme.dart';
import 'package:dstokenbam_example_new/src/widgets/app_bar_dstoken.dart';
import 'package:flutter/material.dart';

class GenerateTokenPage extends StatefulWidget {
  @override
  State<GenerateTokenPage> createState() => _GenerateTokenPage();
}

class _GenerateTokenPage extends State<GenerateTokenPage> {
  final _formKey = GlobalKey<FormState>();
  final _txtUsername = TextEditingController(text: "test30");
  final _txtChannel = TextEditingController(text: "1");
  late Timer _timer;
  String _generate = 'Unknown';
  DateTime _timeStart = DateTime.now();

  @override
  initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      _timer = timer;
      debugPrint("init timer: ${timer.tick}");
    });
  }

  @override
  void dispose() {
    _txtChannel.dispose();
    _txtUsername.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDSToken(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child: _form()),
    );
  }

  Form _form() {
    // input de username
    var inputUsername = TextFormField(
      controller: _txtUsername,
      decoration: ThemeSDK.inputDecoration(hintText: 'Ingrese Usuario'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ingrese Usuario";
        }
        return null;
      },
    );

    // input del canal
    var inputChannel = TextFormField(
      controller: _txtChannel,
      decoration: ThemeSDK.inputDecoration(hintText: 'Ingrese Canal'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ingrese Canal";
        }
        return null;
      },
    );

    // botón generar token
    var buttonGenerate = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
          style: ThemeSDK.actionButtonStyle(),
          onPressed: () async {
            await callGenerateToken(
              channel: _txtChannel.text,
              username: _txtUsername.text,
            );
          },
          child: Text("GENERATE"),
        ),
      ),
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            inputUsername,
            SizedBox(height: 15),
            inputChannel,
            SizedBox(height: 10),
            buttonGenerate,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Response: $_generate\n',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callGenerateToken({
    required String channel,
    required String username,
  }) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    // SDK BAM
    final dsTokenBam = DSTokenBamProvider.instance.dsTokenBam;

    if (!mounted) return;

    _timer.cancel();

    Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      Map<String, String?> res = await dsTokenBam.generateToken(
        username: username,
        channelId: channel,
      );

      _timer = timer;
      setState(() {
        _timeStart = DateTime.now();
        _generate = res.toString() + "\n\n" + _timeStart.toString();
      });

      debugPrint("timer: ${timer.tick}");
    });
  }
}
