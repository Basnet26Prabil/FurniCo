package com.furnico.utils;

import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.Base64;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;

public class CryptoUtil {

    private static final String SECRET_KEY = "FurniCoSecretKey";
    private static final int IV_LENGTH = 12;
    private static final int TAG_LENGTH = 128;

    private CryptoUtil() {
    }

    public static String decryptFormValue(String encryptedValue) throws Exception {
        if (encryptedValue == null || encryptedValue.trim().isEmpty()) {
            return "";
        }

        byte[] payload = Base64.getDecoder().decode(encryptedValue);
        if (payload.length <= IV_LENGTH) {
            throw new IllegalArgumentException("Encrypted form value is not valid.");
        }

        // The browser sends the IV first, followed by the encrypted form value.
        byte[] iv = Arrays.copyOfRange(payload, 0, IV_LENGTH);
        byte[] cipherText = Arrays.copyOfRange(payload, IV_LENGTH, payload.length);

        SecretKeySpec keySpec = new SecretKeySpec(SECRET_KEY.getBytes(StandardCharsets.UTF_8), "AES");
        GCMParameterSpec gcmSpec = new GCMParameterSpec(TAG_LENGTH, iv);

        Cipher cipher = Cipher.getInstance("AES/GCM/NoPadding");
        cipher.init(Cipher.DECRYPT_MODE, keySpec, gcmSpec);

        byte[] plainText = cipher.doFinal(cipherText);
        return new String(plainText, StandardCharsets.UTF_8);
    }
}
