class ApiProvider {
  //TODO: Cambiar el apiendpoint a desa ->  https://dbm1.devbm.gt/DSToken.Api.NewChannel/api/json/reply/
  //TODO: Cambiar el apiendpoint a qa ->  https://dbm1.devbm.gt/DSTokenQA.Api/api/json/reply/
  //TODO: Cambiar el apiendpoint a prod -> https://btk.bam.com.gt/DSToken.Api.V2/api/json/reply/
  //TODO: Cambiar el apiendoint a QADEVEL -> http://api-bam.dstokenonline.com/api/json/reply/
  static const String URL_BASE =
      "https://dbm1.devbm.gt/DSTokenQA.Api/api/json/reply/";
  //TODO: Cambiar el apikey a desa -> 1JV3xOHUtw-je4E0eYvSOOrsm-oZBX-n
  //TODO: Cambiar el apikey a prod -> 1j2f3O_QyA2uyNiuMl7tfnYg_o6OarwK
  //TODO: Cambiar el apikey a QA -> s20vU0mdtTjg9QI0Sc5wPwVAISTxb8Wi
  //TODO: Bearear Token: s20vU0mdtTjg9QI0Sc5wPwVAISTxb8Wi
  static const String API_KEY = "s20vU0mdtTjg9QI0Sc5wPwVAISTxb8Wi";
  static const String SYNC_DEVICE = "SyncToken";
  static const String RESYNC_DEVICE = "ResyncSDK";
  static const String APPROVE_TRANSACTION = "ValidateTokenFromApp ";
  static const String DECLINE_TRANSACTION = "DeclineTransaccion";
  static const String UN_SUBSCRIBE_USER = "UnSubscribeUser";
}
