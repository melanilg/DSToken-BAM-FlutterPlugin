import 'package:dstokenbam_example_new/src/provider/ds_token_bam_provider.dart';
import 'package:dstokenbam_example_new/src/theme/theme.dart';
import 'package:dstokenbam_example_new/src/widgets/app_bar_dstoken.dart';
import 'package:flutter/material.dart';

class ReSyncTokenPage extends StatefulWidget {
  @override
  State<ReSyncTokenPage> createState() => _ReSyncToken();
}

class _ReSyncToken extends State<ReSyncTokenPage> {
  final _formKey = GlobalKey<FormState>();
  String _reSync = 'Unknown';
  final _txtDeviceId = TextEditingController(text: "abc123");

  @override
  initState() {
    super.initState();

    setDeviceId();
  }

  void setDeviceId() async {
    _txtDeviceId.text = 'abc123';
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
    var buttonReSync = Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
          style: ThemeSDK.actionButtonStyle(),
          onPressed: () async {
            await callReSyncToken();
          },
          child: Text("RESYNC"),
        ),
      ),
    );

    var inputDeviceId = TextFormField(
      controller: _txtDeviceId,
      decoration: ThemeSDK.inputDecoration(hintText: 'Ingrese Device Id'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ingrese Device Id";
        }
        return null;
      },
    );

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              buttonReSync,
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    inputDeviceId,
                    SizedBox(height: 15),
                    Text(
                      'Response: $_reSync\n',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> callReSyncToken() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String deviceId = "abc123";
    final dsTokenBam = DSTokenBamProvider.instance.dsTokenBam;
    Map<String, String?> res = await dsTokenBam.reSyncToken(
      deviceId: deviceId,
    );
    setState(() {
      _reSync = res.toString();
    });
  }
}
