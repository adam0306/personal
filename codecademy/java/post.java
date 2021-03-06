package org.kodejava.example.httpclient;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;

public class HttpPostJsonExample {
    public static void main(String[] args) throws Exception {
        String payload = "data={" +
                "\"name\": \"admin\", " +
                "\"address\": \"address\", " +
                "\"userName\": \"Administrator\"" +
                "\"platformId\": \"platform\"" +
                "\"safeName\": \"safe\"" +
                "}";
        StringEntity entity = new StringEntity(payload,
                ContentType.APPLICATION_FORM_URLENCODED);

        HttpClient httpClient = HttpClientBuilder.create().build();
        HttpPost request = new HttpPost("http://{{BaseURL}}/PasswordVault/api/Accounts");
        request.setEntity(entity);

        HttpResponse response = httpClient.execute(request);
        System.out.println(response.getStatusLine().getStatusCode());
    }
}
