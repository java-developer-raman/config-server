package com.sharma.config.server.controller;

import com.sharma.config.server.domain.PayloadToDecrypt;
import com.sharma.config.server.domain.PayloadToEncrypt;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.vault.core.VaultTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class EncryptionDecryptionUsingVaultController {

    @Autowired
    private VaultTemplate vaultTemplate;

    @PostMapping(value = "/encrypt-with-vault", produces = "application/json", consumes = "application/json")
    @ResponseBody
    public String encrypt(@RequestBody PayloadToEncrypt payloadToEncrypt) {
        String encryptedText = vaultTemplate.opsForTransit().encrypt(payloadToEncrypt.getApplicationName(), payloadToEncrypt.getTextToEncrypt());
        if(encryptedText.endsWith("\n")){
            encryptedText = encryptedText.substring(0, encryptedText.length() - 1);
        }
        return encryptedText;
    }

    @PostMapping(value = "/decrypt-with-vault", produces = "application/json", consumes = "application/json")
    @ResponseBody
    public String decrypt(@RequestBody PayloadToDecrypt payloadToDecrypt) {
        String decrytedText = vaultTemplate.opsForTransit().decrypt(payloadToDecrypt.getApplicationName(), payloadToDecrypt.getTextToDecrypt());
        if(decrytedText.endsWith("\n")){
            decrytedText = decrytedText.substring(0, decrytedText.length() - 1);
        }
        return decrytedText;
    }

}
