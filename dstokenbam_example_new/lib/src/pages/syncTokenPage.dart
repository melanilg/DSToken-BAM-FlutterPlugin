import 'package:dstokenbam_example_new/src/provider/ds_token_bam_provider.dart';
import 'package:dstokenbam_example_new/src/theme/theme.dart';
import 'package:dstokenbam_example_new/src/widgets/app_bar_dstoken.dart';
import 'package:flutter/material.dart';

class SyncTokenPage extends StatefulWidget {
  @override
  State<SyncTokenPage> createState() => _SyncTokenPage();
}

class _SyncTokenPage extends State<SyncTokenPage> {
  String _sync = 'Unknown';
  final _formKey = GlobalKey<FormState>();
  final _txtUsername = TextEditingController(text: "melTest");
  final _txtChannel = TextEditingController(text: "1");
  final _txtDeviceId = TextEditingController(text: "abc123");
  final _txtOtp = TextEditingController();

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
    return Center(
      child: Scaffold(
        appBar: AppBarDSToken(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(child: _form()),
      ),
    );
  }

  Form _form() {
    // input username
    var inputUsername = TextFormField(
        controller: _txtUsername,
        decoration: ThemeSDK.inputDecoration(hintText: 'Ingrese Usuario'),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Ingrese Usuario";
          }
          return null;
        });
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

    var inputOTP = TextFormField(
      controller: _txtOtp,
      decoration: ThemeSDK.inputDecoration(hintText: 'Ingrese OTP'),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Ingrese OTP";
        }
        return null;
      },
    );

    var buttonSync = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
          style: ThemeSDK.actionButtonStyle(),
          onPressed: () async {
            await callSyncToken(
              channel: _txtChannel.text,
              username: _txtUsername.text,
              otp: _txtOtp.text,
            );
          },
          child: Text("SYNC"),
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
            inputDeviceId,
            SizedBox(height: 15),
            inputChannel,
            SizedBox(height: 15),
            inputOTP,
            SizedBox(height: 10),
            buttonSync,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Response: $_sync\n',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callSyncToken({
    required String channel,
    required String username,
    required String otp,
  }) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    String deviceId = _txtDeviceId.text;
    // SDK BAM
    final dsTokenBam = DSTokenBamProvider.instance.dsTokenBam;
    // Petición de sincronización
    Map<String, String?> res = await dsTokenBam.syncToken(
      username: username,
      channelId: channel,
      deviceId: deviceId ?? "abc123",
      otp: otp,
    );

    setState(() {
      _sync = res.toString();
    });
  }
}
