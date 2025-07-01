import 'package:dstokenbam_example_new/src/provider/ds_token_bam_provider.dart';
import 'package:dstokenbam_example_new/src/theme/theme.dart';
import 'package:dstokenbam_example_new/src/widgets/app_bar_dstoken.dart';
import 'package:flutter/material.dart';

class DeleteTokenPage extends StatefulWidget {
  @override
  State<DeleteTokenPage> createState() => _DeleteTokenPage();
}

class _DeleteTokenPage extends State<DeleteTokenPage> {
  final _formKey = GlobalKey<FormState>();
  final _txtUsername = TextEditingController(text: "test30");
  final _txtChannel = TextEditingController(text: "1");
  String? _delete = 'Unknown';
  String? _unsubscribeAwnser = 'Unknown';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDSToken(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(child: _form()),
    );
  }

  Form _form() {
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

    var buttonDelete = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: SizedBox(
        width: 250,
        child: ElevatedButton(
          style: ThemeSDK.actionButtonStyle(),
          onPressed: () async {
            await callDeleteToken(
              channel: _txtChannel.text,
              username: _txtUsername.text,
            );
          },
          child: Text("DELETE"),
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
            buttonDelete,
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Response: $_delete\n',
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> callDeleteToken({
    required String channel,
    required String username,
  }) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final dsTokenBam = DSTokenBamProvider.instance.dsTokenBam;

    Map<String, String?> resUnsubscribe = await dsTokenBam.unSubscribeUser(
      username: _txtUsername.text,
      channelId: _txtChannel.text,
    );
    _unsubscribeAwnser = resUnsubscribe['code'];
    if (_unsubscribeAwnser != null) {
      if (_unsubscribeAwnser == "205") {
        Map<String, String?> resDelete = await dsTokenBam.deleteToken(
          channelId: channel,
          username: username,
        );
        setState(() {
          _delete = resDelete.toString();
        });
      } else {
        setState(() {
          _delete = resUnsubscribe.toString();
        });
      }
    }
  }
}
