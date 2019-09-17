package com.sharma.config.server.domain;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonProperty;

@JsonIgnoreProperties(ignoreUnknown = true)
public class PayloadToEncrypt {
    @JsonProperty
    private String textToEncrypt;

    @JsonProperty
    private String applicationName;

    public String getTextToEncrypt() {
        return textToEncrypt;
    }

    public void setTextToEncrypt(String textToEncrypt) {
        this.textToEncrypt = textToEncrypt;
    }

    public String getApplicationName() {
        return applicationName;
    }

    public void setApplicationName(String applicationName) {
        this.applicationName = applicationName;
    }

}
