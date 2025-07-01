package com.develsystems.DSTokenBam.otp;

import java.io.IOException;

public class SeedConvertor {

    public static final int HEX_FORMAT = 0;
    public static final int BASE32_FORMAT = 1;
    public static final int BASE64_FORMAT = 2;

    public static byte[] ConvertFromEncodingToBA(String input, int currentFormat) throws IOException{

        if(currentFormat == 0){
            //hex
            return stringToHex(input);
        }else if(currentFormat == 1){
            //base 32
            Base32 base32 = new Base32();
            return base32.decodeBytes(input);
        }else if(currentFormat == 2){
            //base64
            return Base64.decode(input);
        }else
            return null;
    }

    public static String ConvertFromBA(byte[] input, int targetFormat){
        if(targetFormat == 0){
            //hex
            return byteArrayToHexString(input);
        }else if(targetFormat == 1){
            //base 32
            Base32 base32 = new Base32();
            return base32.encodeBytes(input);
        }else if(targetFormat == 2){
            //base64
            return Base64.encodeBytes(input);
        }else
            return null;
    }

    public static byte[] stringToHex(String hexInputString){

        byte[] bts = new byte[hexInputString.length() / 2];

        for (int i = 0; i < bts.length; i++) {
            bts[i] = (byte) Integer.parseInt(hexInputString.substring(2*i, 2*i+2), 16);
        }

        return bts;
    }

    public static String byteArrayToHexString(byte[] digest) {

        StringBuffer buffer = new StringBuffer();

        for (int i =0; i < digest.length; i++) {
            String hex = Integer.toHexString(0xff & digest[i]);

            if(hex.length() == 1)
                buffer.append("0");

            buffer.append(hex);

        }

        return buffer.toString();
    }
}
