package com.sharma.config.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PayloadToDecrypt {
    @JsonProperty
    private String textToDecrypt;

    @JsonProperty
    private String applicationName;

    public String getTextToDecrypt() {
        return textToDecrypt;
    }

    public void setTextToDecrypt(String textToDecrypt) {
        this.textToDecrypt = textToDecrypt;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public void setApplicationName(String applicationName) {
        this.applicationName = applicationName;
    }

}
